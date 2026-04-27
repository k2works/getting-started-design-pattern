package pattern.composite;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

class CompositeTest {

    @Test
    void leafTaskReturnsItsTimeRequired() {
        Task addDry = new AddDryIngredientsTask();
        assertEquals(1.0, addDry.getTimeRequired());
    }

    @Test
    void leafTaskHasOneBasicTask() {
        Task mix = new MixTask();
        assertEquals(1, mix.getTotalBasicTasks());
    }

    @Test
    void makeBatterTaskSumsSubTaskTimes() {
        CompositeTask makeBatter = new MakeBatterTask();
        // AddDryIngredients(1.0) + AddLiquids(1.0) + Mix(3.0) = 5.0
        assertEquals(5.0, makeBatter.getTimeRequired());
    }

    @Test
    void makeBatterTaskCountsBasicTasks() {
        CompositeTask makeBatter = new MakeBatterTask();
        assertEquals(3, makeBatter.getTotalBasicTasks());
    }

    @Test
    void makeCakeTaskSumsAllSubTaskTimes() {
        CompositeTask makeCake = new MakeCakeTask();
        // MakeBatter(5.0) + FillPan(2.0) + Bake(10.0) + Frost(4.0) + LickSpoon(1.0) = 22.0
        assertEquals(22.0, makeCake.getTimeRequired());
    }

    @Test
    void makeCakeTaskCountsAllBasicTasks() {
        CompositeTask makeCake = new MakeCakeTask();
        // MakeBatter(3) + FillPan(1) + Bake(1) + Frost(1) + LickSpoon(1) = 7
        assertEquals(7, makeCake.getTotalBasicTasks());
    }

    @Test
    void canAddAndRemoveSubTasks() {
        CompositeTask composite = new CompositeTask("テスト複合タスク");
        Task bake = new BakeTask();

        composite.addSubTask(bake);
        assertEquals(10.0, composite.getTimeRequired());
        assertEquals(composite, bake.getParent());

        composite.removeSubTask(bake);
        assertEquals(0.0, composite.getTimeRequired());
        assertNull(bake.getParent());
    }

    @Test
    void taskHasName() {
        Task task = new BakeTask();
        assertEquals("焼く", task.getName());
    }

    @Test
    void compositeTaskHasName() {
        CompositeTask makeCake = new MakeCakeTask();
        assertEquals("ケーキを作る", makeCake.getName());
    }

    @Test
    void canAccessSubTaskByIndex() {
        CompositeTask makeBatter = new MakeBatterTask();
        assertEquals("乾燥材料を加える", makeBatter.getSubTask(0).getName());
        assertEquals("液体材料を加える", makeBatter.getSubTask(1).getName());
        assertEquals("混ぜる", makeBatter.getSubTask(2).getName());
    }
}
