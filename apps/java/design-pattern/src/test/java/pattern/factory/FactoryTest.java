package pattern.factory;

import org.junit.jupiter.api.Test;

import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

class FactoryTest {

    @Test
    void duckBehavior() {
        Animal duck = new Duck();
        assertEquals("Quack!", duck.speak());
        assertEquals("Duck is eating.", duck.eat());
        assertEquals("Duck is sleeping.", duck.sleep());
    }

    @Test
    void duckPondSimulatesOneDay() {
        Pond pond = new DuckPond(2, 1);
        List<String> output = pond.simulateOneDay();

        assertTrue(output.contains("WaterLily is growing."));
        assertTrue(output.contains("Quack!"));
        assertTrue(output.contains("Duck is eating."));
        assertTrue(output.contains("Duck is sleeping."));
    }

    @Test
    void frogPondSimulatesOneDay() {
        Pond pond = new FrogPond(1, 1);
        List<String> output = pond.simulateOneDay();

        assertTrue(output.contains("Algae is growing."));
        assertTrue(output.contains("Croak!"));
        assertTrue(output.contains("Frog is eating."));
    }

    @Test
    void abstractFactoryCreatesOrganisms() {
        OrganismFactory factory = new OrganismFactory(Tiger::new, Tree::new);
        Animal animal = factory.newAnimal();
        Plant plant = factory.newPlant();

        assertEquals("Roar!", animal.speak());
        assertEquals("Tree is growing.", plant.grow());
    }

    @Test
    void habitatUsesAbstractFactory() {
        OrganismFactory factory = new OrganismFactory(Duck::new, WaterLily::new);
        Habitat habitat = new Habitat(2, 1, factory);
        List<String> output = habitat.simulateOneDay();

        assertTrue(output.contains("WaterLily is growing."));
        assertTrue(output.contains("Quack!"));
        assertEquals(7, output.size()); // 1 plant + 2 animals * 3 actions
    }

    @Test
    void tigerSpeaksRoar() {
        Animal tiger = new Tiger();
        assertEquals("Roar!", tiger.speak());
        assertEquals("Tiger is eating.", tiger.eat());
        assertEquals("Tiger is sleeping.", tiger.sleep());
    }
}
