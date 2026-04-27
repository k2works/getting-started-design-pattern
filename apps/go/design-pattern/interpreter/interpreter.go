// Package interpreter demonstrates the Interpreter pattern in Go.
// Expressions form a recursive AST that evaluates against a directory listing.
package interpreter

import (
	"os"
	"path/filepath"
	"strings"
)

// Expression is the abstract expression interface.
type Expression interface {
	Evaluate(dir string) []string
}

// All returns all files in the directory.
type All struct{}

func (a *All) Evaluate(dir string) []string {
	entries, err := os.ReadDir(dir)
	if err != nil {
		return nil
	}
	var result []string
	for _, entry := range entries {
		if !entry.IsDir() {
			result = append(result, entry.Name())
		}
	}
	return result
}

// FileName matches files whose name contains the given pattern.
type FileName struct {
	Pattern string
}

func (f *FileName) Evaluate(dir string) []string {
	all := (&All{}).Evaluate(dir)
	var result []string
	for _, name := range all {
		matched, _ := filepath.Match(f.Pattern, name)
		if matched {
			result = append(result, name)
		}
	}
	return result
}

// Bigger matches files larger than the given size in bytes.
type Bigger struct {
	Size  int64
	Inner Expression
}

func (b *Bigger) Evaluate(dir string) []string {
	candidates := b.Inner.Evaluate(dir)
	var result []string
	for _, name := range candidates {
		info, err := os.Stat(filepath.Join(dir, name))
		if err != nil {
			continue
		}
		if info.Size() > b.Size {
			result = append(result, name)
		}
	}
	return result
}

// Not negates an expression: returns files in All that are NOT in the inner expression.
type Not struct {
	Inner Expression
}

func (n *Not) Evaluate(dir string) []string {
	all := (&All{}).Evaluate(dir)
	excluded := toSet(n.Inner.Evaluate(dir))
	var result []string
	for _, name := range all {
		if !excluded[name] {
			result = append(result, name)
		}
	}
	return result
}

// And returns the intersection of two expressions.
type And struct {
	Left  Expression
	Right Expression
}

func (a *And) Evaluate(dir string) []string {
	left := toSet(a.Left.Evaluate(dir))
	right := a.Right.Evaluate(dir)
	var result []string
	for _, name := range right {
		if left[name] {
			result = append(result, name)
		}
	}
	return result
}

// Or returns the union of two expressions.
type Or struct {
	Left  Expression
	Right Expression
}

func (o *Or) Evaluate(dir string) []string {
	seen := make(map[string]bool)
	var result []string
	for _, name := range o.Left.Evaluate(dir) {
		if !seen[name] {
			seen[name] = true
			result = append(result, name)
		}
	}
	for _, name := range o.Right.Evaluate(dir) {
		if !seen[name] {
			seen[name] = true
			result = append(result, name)
		}
	}
	return result
}

// WithExtension is a convenience: matches files ending with the given extension.
type WithExtension struct {
	Ext string
}

func (w *WithExtension) Evaluate(dir string) []string {
	all := (&All{}).Evaluate(dir)
	var result []string
	ext := w.Ext
	if !strings.HasPrefix(ext, ".") {
		ext = "." + ext
	}
	for _, name := range all {
		if strings.HasSuffix(name, ext) {
			result = append(result, name)
		}
	}
	return result
}

func toSet(items []string) map[string]bool {
	s := make(map[string]bool)
	for _, item := range items {
		s[item] = true
	}
	return s
}
