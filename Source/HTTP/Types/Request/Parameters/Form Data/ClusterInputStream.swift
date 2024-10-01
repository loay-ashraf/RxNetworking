//
//  ClusterInputStream.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 01/10/2024.
//

import Foundation

class ClusterInputStream: InputStream {

    private var inputStreams: [InputStream]
    private var currentIndex: Int
    private var _streamStatus: Stream.Status
    private var _streamError: Error?
    private var _delegate: StreamDelegate?

    init(inputStreams: [InputStream]) {
        self.inputStreams = inputStreams
        self.currentIndex = 0
        self._streamStatus = .notOpen
        self._streamError = nil
        super.init(data: Data())
    }

    override var streamStatus: Stream.Status {
        return _streamStatus
    }

    override var streamError: Error? {
        return _streamError
    }

    override var delegate: StreamDelegate? {
        get {
            return _delegate
        }
        set {
            _delegate = newValue
        }
    }

    override func read(_ buffer: UnsafeMutablePointer<UInt8>, maxLength: Int) -> Int {
        if _streamStatus == .closed{
            return 0
        }

        var totalNumberOfBytesRead = 0

        while totalNumberOfBytesRead < maxLength {
            if currentIndex == inputStreams.count {
                self.close()
                break
            }
            
            let currentInputStream = inputStreams[currentIndex]

            if currentInputStream.streamStatus != .open {
                currentInputStream.open()
            }

            if !currentInputStream.hasBytesAvailable {
                self.currentIndex += 1
                continue
            }

            let remainingLength = maxLength - totalNumberOfBytesRead

            let numberOfBytesRead = currentInputStream.read(&buffer[totalNumberOfBytesRead], maxLength: remainingLength)

            if numberOfBytesRead == 0 {
                self.currentIndex += 1
                continue
            }

            if numberOfBytesRead == -1 {
                self._streamError = currentInputStream.streamError
                self._streamStatus = .error
                return -1
            }

            totalNumberOfBytesRead += numberOfBytesRead
        }

        return totalNumberOfBytesRead
    }

    override func getBuffer(_ buffer: UnsafeMutablePointer<UnsafeMutablePointer<UInt8>?>, length len: UnsafeMutablePointer<Int>) -> Bool {
        return false
    }

    override var hasBytesAvailable: Bool {
        return true
    }

    override func open() {
        guard self._streamStatus == .open else {
            return
        }
        self._streamStatus = .open
    }

    override func close() {
        self._streamStatus = .closed
    }

    override func property(forKey key: Stream.PropertyKey) -> Any? {
        return nil
    }

    override func setProperty(_ property: Any?, forKey key: Stream.PropertyKey) -> Bool {
        return false
    }

    override func schedule(in aRunLoop: RunLoop, forMode mode: RunLoop.Mode) { }

    override func remove(from aRunLoop: RunLoop, forMode mode: RunLoop.Mode) { }
    
    func append(_ newElement: InputStream) {
        inputStreams.append(newElement)
    }
    
    func append(contentsOf streams: [InputStream]) {
        inputStreams.append(contentsOf: streams)
    }

}
