package composite

import "testing"

func TestLeafTaskTimeRequired(t *testing.T) {
	task := &AddMixins{TaskName: "材料を加える"}
	if task.GetTimeRequired() != 1.0 {
		t.Errorf("期待値 1.0, 実際 %f", task.GetTimeRequired())
	}
}

func TestLeafTaskBasicCount(t *testing.T) {
	task := &BakeTask{TaskName: "焼く"}
	if task.TotalBasicTasks() != 1 {
		t.Errorf("期待値 1, 実際 %d", task.TotalBasicTasks())
	}
}

func TestCompositeTaskTotalTime(t *testing.T) {
	cake := NewMakeCakeTask()
	expected := 34.5 // 1 + 3 + 25 + 4 + 1.5
	if cake.GetTimeRequired() != expected {
		t.Errorf("期待値 %f, 実際 %f", expected, cake.GetTimeRequired())
	}
}

func TestCompositeTaskBasicCount(t *testing.T) {
	cake := NewMakeCakeTask()
	if cake.TotalBasicTasks() != 5 {
		t.Errorf("期待値 5, 実際 %d", cake.TotalBasicTasks())
	}
}

func TestNestedComposite(t *testing.T) {
	inner := &CompositeTask{
		TaskName: "準備",
		SubTasks: []Task{
			&AddMixins{TaskName: "材料を加える"},
			&MixTask{TaskName: "混ぜる"},
		},
	}
	outer := &CompositeTask{
		TaskName: "全工程",
		SubTasks: []Task{
			inner,
			&BakeTask{TaskName: "焼く"},
		},
	}

	expectedTime := 1.0 + 3.0 + 25.0
	if outer.GetTimeRequired() != expectedTime {
		t.Errorf("期待値 %f, 実際 %f", expectedTime, outer.GetTimeRequired())
	}
	if outer.TotalBasicTasks() != 3 {
		t.Errorf("期待値 3, 実際 %d", outer.TotalBasicTasks())
	}
}

func TestAddSubTask(t *testing.T) {
	c := &CompositeTask{TaskName: "テスト"}
	c.AddSubTask(&AddMixins{TaskName: "追加"})

	if len(c.SubTasks) != 1 {
		t.Errorf("期待値 1, 実際 %d", len(c.SubTasks))
	}
}

func TestRemoveSubTask(t *testing.T) {
	cake := NewMakeCakeTask()
	cake.RemoveSubTask()

	if len(cake.SubTasks) != 4 {
		t.Errorf("期待値 4, 実際 %d", len(cake.SubTasks))
	}
}

func TestCompositeTaskName(t *testing.T) {
	cake := NewMakeCakeTask()
	if cake.Name() != "ケーキを作る" {
		t.Errorf("期待値 'ケーキを作る', 実際 %q", cake.Name())
	}
}
