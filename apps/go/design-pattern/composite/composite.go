// Package composite demonstrates the Composite pattern in Go.
// We use an interface and struct embedding to model part-whole hierarchies.
package composite

// Task is the component interface shared by both leaf and composite tasks.
type Task interface {
	Name() string
	GetTimeRequired() float64
	TotalBasicTasks() int
}

// AddMixins is a leaf task for adding mixins to a cake.
type AddMixins struct {
	TaskName string
}

func (a *AddMixins) Name() string            { return a.TaskName }
func (a *AddMixins) GetTimeRequired() float64 { return 1.0 }
func (a *AddMixins) TotalBasicTasks() int     { return 1 }

// MixTask is a leaf task for mixing ingredients.
type MixTask struct {
	TaskName string
}

func (m *MixTask) Name() string            { return m.TaskName }
func (m *MixTask) GetTimeRequired() float64 { return 3.0 }
func (m *MixTask) TotalBasicTasks() int     { return 1 }

// BakeTask is a leaf task for baking.
type BakeTask struct {
	TaskName string
}

func (b *BakeTask) Name() string            { return b.TaskName }
func (b *BakeTask) GetTimeRequired() float64 { return 25.0 }
func (b *BakeTask) TotalBasicTasks() int     { return 1 }

// FrostTask is a leaf task for frosting a cake.
type FrostTask struct {
	TaskName string
}

func (f *FrostTask) Name() string            { return f.TaskName }
func (f *FrostTask) GetTimeRequired() float64 { return 4.0 }
func (f *FrostTask) TotalBasicTasks() int     { return 1 }

// PackageTask is a leaf task for packaging.
type PackageTask struct {
	TaskName string
}

func (p *PackageTask) Name() string            { return p.TaskName }
func (p *PackageTask) GetTimeRequired() float64 { return 1.5 }
func (p *PackageTask) TotalBasicTasks() int     { return 1 }

// CompositeTask is a composite task that contains sub-tasks.
type CompositeTask struct {
	TaskName string
	SubTasks []Task
}

func (c *CompositeTask) Name() string { return c.TaskName }

func (c *CompositeTask) GetTimeRequired() float64 {
	total := 0.0
	for _, t := range c.SubTasks {
		total += t.GetTimeRequired()
	}
	return total
}

func (c *CompositeTask) TotalBasicTasks() int {
	total := 0
	for _, t := range c.SubTasks {
		total += t.TotalBasicTasks()
	}
	return total
}

// AddSubTask adds a child task.
func (c *CompositeTask) AddSubTask(t Task) {
	c.SubTasks = append(c.SubTasks, t)
}

// RemoveSubTask removes the last child task.
func (c *CompositeTask) RemoveSubTask() {
	if len(c.SubTasks) > 0 {
		c.SubTasks = c.SubTasks[:len(c.SubTasks)-1]
	}
}

// NewMakeCakeTask creates a composite task for making a cake.
func NewMakeCakeTask() *CompositeTask {
	return &CompositeTask{
		TaskName: "ケーキを作る",
		SubTasks: []Task{
			&AddMixins{TaskName: "材料を加える"},
			&MixTask{TaskName: "混ぜる"},
			&BakeTask{TaskName: "焼く"},
			&FrostTask{TaskName: "フロスティング"},
			&PackageTask{TaskName: "箱に詰める"},
		},
	}
}
