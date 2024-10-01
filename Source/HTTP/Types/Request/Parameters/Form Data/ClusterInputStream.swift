//
//  ClusterInputStream.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 01/10/2024.
//

import Foundation

/// A custom input stream that aggregates multiple `InputStream` instances and
/// reads from them sequentially. It allows for reading data from a collection
/// of input streams as if they were a single continuous stream.
///
/// The `ClusterInputStream` class is useful for handling multipart data, allowing
/// for efficient reading from multiple sources.
final class ClusterInputStream: InputStream {
    
    /// An array of `InputStream` instances that this stream will read from.
    private var inputStreams: [InputStream]
    
    /// The index of the currently active input stream in the array.
    private var currentIndex: Int
    
    /// The current status of the stream.
    private var _streamStatus: Stream.Status
    
    /// An error encountered while reading from the stream, if any.
    private var _streamError: Error?
    
    /// The delegate for stream events.
    private var _delegate: StreamDelegate?
    
    /// Initializes a new `ClusterInputStream` with the provided input streams.
    ///
    /// - Parameter inputStreams: An array of `InputStream` instances to aggregate.
    init(inputStreams: [InputStream]) {
        self.inputStreams = inputStreams
        self.currentIndex = 0
        self._streamStatus = .notOpen
        self._streamError = nil
        super.init(data: Data())
    }
    
    /// The current status of the stream.
    override var streamStatus: Stream.Status {
        return _streamStatus
    }
    
    /// The error encountered during stream operations, if any.
    override var streamError: Error? {
        return _streamError
    }
    
    /// The delegate for stream events.
    override var delegate: StreamDelegate? {
        get {
            return _delegate
        }
        set {
            _delegate = newValue
        }
    }
    
    /// Reads data from the current input stream and stores it in the provided buffer.
    ///
    /// - Parameters:
    ///   - buffer: A pointer to a buffer where the read data will be stored.
    ///   - maxLength: The maximum number of bytes to read into the buffer.
    /// - Returns: The number of bytes read, or 0 if the stream is closed.
    override func read(_ buffer: UnsafeMutablePointer<UInt8>, maxLength: Int) -> Int {
        if _streamStatus == .closed {
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
    
    /// Returns whether there are bytes available to read in the stream.
    override var hasBytesAvailable: Bool {
        return true
    }
    
    /// Opens the input stream for reading.
    override func open() {
        guard self._streamStatus == .open else {
            return
        }
        self._streamStatus = .open
    }
    
    /// Closes the input stream.
    override func close() {
        self._streamStatus = .closed
    }
    
    /// Retrieves the property value for the specified key.
    ///
    /// - Parameter key: The key for the property to retrieve.
    /// - Returns: The property value, or nil if the property does not exist.
    override func property(forKey key: Stream.PropertyKey) -> Any? {
        return nil
    }
    
    /// Sets the property value for the specified key.
    ///
    /// - Parameters:
    ///   - property: The property value to set.
    ///   - key: The key for the property to set.
    /// - Returns: A boolean indicating whether the property was successfully set.
    override func setProperty(_ property: Any?, forKey key: Stream.PropertyKey) -> Bool {
        return false
    }
    
    /// Schedules the stream for reading in the specified run loop and mode.
    ///
    /// - Parameters:
    ///   - aRunLoop: The run loop to schedule the stream in.
    ///   - mode: The mode in which to schedule the stream.
    override func schedule(in aRunLoop: RunLoop, forMode mode: RunLoop.Mode) { }
    
    /// Removes the stream from the specified run loop and mode.
    ///
    /// - Parameters:
    ///   - aRunLoop: The run loop from which to remove the stream.
    ///   - mode: The mode from which to remove the stream.
    override func remove(from aRunLoop: RunLoop, forMode mode: RunLoop.Mode) { }
    
    /// Appends a new input stream to the list of input streams.
    ///
    /// - Parameter newElement: The new `InputStream` to append.
    func append(_ newElement: InputStream) {
        inputStreams.append(newElement)
    }
    
    /// Appends a collection of input streams to the list of input streams.
    ///
    /// - Parameter streams: An array of `InputStream` instances to append.
    func append(contentsOf streams: [InputStream]) {
        inputStreams.append(contentsOf: streams)
    }
}
