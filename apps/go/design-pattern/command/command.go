// Package command demonstrates the Command pattern in Go.
// Commands are represented as an interface with Execute, Undo, and Description.
package command

import (
	"os"
	"path/filepath"
)

// Command is the interface for all commands.
type Command interface {
	Execute() error
	Undo() error
	Description() string
}

// CreateFileCommand creates a file with given content.
type CreateFileCommand struct {
	Path    string
	Content string
}

func (c *CreateFileCommand) Execute() error {
	dir := filepath.Dir(c.Path)
	if err := os.MkdirAll(dir, 0755); err != nil {
		return err
	}
	return os.WriteFile(c.Path, []byte(c.Content), 0644)
}

func (c *CreateFileCommand) Undo() error {
	return os.Remove(c.Path)
}

func (c *CreateFileCommand) Description() string {
	return "ファイル作成: " + c.Path
}

// DeleteFileCommand deletes a file, saving its content for undo.
type DeleteFileCommand struct {
	Path           string
	savedContent   []byte
	savedFileExist bool
}

func (d *DeleteFileCommand) Execute() error {
	data, err := os.ReadFile(d.Path)
	if err != nil {
		return err
	}
	d.savedContent = data
	d.savedFileExist = true
	return os.Remove(d.Path)
}

func (d *DeleteFileCommand) Undo() error {
	if !d.savedFileExist {
		return nil
	}
	dir := filepath.Dir(d.Path)
	if err := os.MkdirAll(dir, 0755); err != nil {
		return err
	}
	return os.WriteFile(d.Path, d.savedContent, 0644)
}

func (d *DeleteFileCommand) Description() string {
	return "ファイル削除: " + d.Path
}

// CompositeCommand executes multiple commands as a group.
type CompositeCommand struct {
	Commands []Command
	executed []Command
}

func (cc *CompositeCommand) Execute() error {
	cc.executed = nil
	for _, cmd := range cc.Commands {
		if err := cmd.Execute(); err != nil {
			// Undo already executed commands on failure
			for i := len(cc.executed) - 1; i >= 0; i-- {
				_ = cc.executed[i].Undo()
			}
			return err
		}
		cc.executed = append(cc.executed, cmd)
	}
	return nil
}

func (cc *CompositeCommand) Undo() error {
	for i := len(cc.executed) - 1; i >= 0; i-- {
		if err := cc.executed[i].Undo(); err != nil {
			return err
		}
	}
	cc.executed = nil
	return nil
}

func (cc *CompositeCommand) Description() string {
	return "複合コマンド"
}
