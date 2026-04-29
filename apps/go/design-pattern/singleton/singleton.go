// Package singleton demonstrates the Singleton pattern in Go.
// We use sync.Once to ensure thread-safe lazy initialization.
package singleton

import (
	"fmt"
	"strings"
	"sync"
)

// Logger is a singleton logger.
type Logger struct {
	mu       sync.Mutex
	messages []string
}

var (
	instance *Logger
	once     sync.Once
)

// GetInstance returns the singleton Logger instance.
func GetInstance() *Logger {
	once.Do(func() {
		instance = &Logger{}
	})
	return instance
}

// Log adds a message to the logger.
func (l *Logger) Log(message string) {
	l.mu.Lock()
	defer l.mu.Unlock()
	l.messages = append(l.messages, message)
}

// Messages returns all logged messages.
func (l *Logger) Messages() []string {
	l.mu.Lock()
	defer l.mu.Unlock()
	result := make([]string, len(l.messages))
	copy(result, l.messages)
	return result
}

// Count returns the number of logged messages.
func (l *Logger) Count() int {
	l.mu.Lock()
	defer l.mu.Unlock()
	return len(l.messages)
}

// Clear removes all messages.
func (l *Logger) Clear() {
	l.mu.Lock()
	defer l.mu.Unlock()
	l.messages = nil
}

// String returns all messages as a single string.
func (l *Logger) String() string {
	l.mu.Lock()
	defer l.mu.Unlock()
	return strings.Join(l.messages, "\n")
}

// ResetForTesting resets the singleton (only for testing).
func ResetForTesting() {
	once = sync.Once{}
	instance = nil
}

// Describe returns a description of the logger.
func (l *Logger) Describe() string {
	return fmt.Sprintf("Logger with %d messages", l.Count())
}
