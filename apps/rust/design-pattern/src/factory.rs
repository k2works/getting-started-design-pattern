/// Factory pattern
///
/// OrganismFactory creates Animals and Plants.
/// Habitat combines a factory with the organisms it produces.

#[derive(Debug, Clone, PartialEq)]
pub enum Animal {
    Duck(String),
    Frog(String),
    Tiger(String),
}

impl Animal {
    pub fn name(&self) -> &str {
        match self {
            Animal::Duck(n) | Animal::Frog(n) | Animal::Tiger(n) => n,
        }
    }

    pub fn speak(&self) -> String {
        match self {
            Animal::Duck(_) => "Quack!".to_string(),
            Animal::Frog(_) => "Croak!".to_string(),
            Animal::Tiger(_) => "Roar!".to_string(),
        }
    }

    pub fn eat(&self) -> String {
        match self {
            Animal::Duck(_) => "Eats bread crumbs".to_string(),
            Animal::Frog(_) => "Eats flies".to_string(),
            Animal::Tiger(_) => "Eats meat".to_string(),
        }
    }

    pub fn sleep(&self) -> String {
        match self {
            Animal::Duck(_) => "Sleeps on water".to_string(),
            Animal::Frog(_) => "Sleeps on lily pad".to_string(),
            Animal::Tiger(_) => "Sleeps in den".to_string(),
        }
    }
}

#[derive(Debug, Clone, PartialEq)]
pub enum Plant {
    WaterLily(String),
    Algae(String),
    Tree(String),
}

impl Plant {
    pub fn name(&self) -> &str {
        match self {
            Plant::WaterLily(n) | Plant::Algae(n) | Plant::Tree(n) => n,
        }
    }

    pub fn grow(&self) -> String {
        match self {
            Plant::WaterLily(_) => "Grows on water surface".to_string(),
            Plant::Algae(_) => "Grows underwater".to_string(),
            Plant::Tree(_) => "Grows on land".to_string(),
        }
    }
}

#[derive(Debug, Clone, Copy, PartialEq)]
pub enum HabitatType {
    Pond,
    Jungle,
}

pub struct OrganismFactory;

impl OrganismFactory {
    pub fn create_animal(habitat: HabitatType, name: &str) -> Animal {
        match habitat {
            HabitatType::Pond => Animal::Duck(name.to_string()),
            HabitatType::Jungle => Animal::Tiger(name.to_string()),
        }
    }

    pub fn create_plant(habitat: HabitatType, name: &str) -> Plant {
        match habitat {
            HabitatType::Pond => Plant::WaterLily(name.to_string()),
            HabitatType::Jungle => Plant::Tree(name.to_string()),
        }
    }
}

pub struct Habitat {
    pub habitat_type: HabitatType,
    pub animals: Vec<Animal>,
    pub plants: Vec<Plant>,
}

impl Habitat {
    pub fn new(habitat_type: HabitatType) -> Self {
        Self {
            habitat_type,
            animals: Vec::new(),
            plants: Vec::new(),
        }
    }

    pub fn add_animal(&mut self, name: &str) {
        self.animals
            .push(OrganismFactory::create_animal(self.habitat_type, name));
    }

    pub fn add_plant(&mut self, name: &str) {
        self.plants
            .push(OrganismFactory::create_plant(self.habitat_type, name));
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn pond_creates_ducks() {
        let animal = OrganismFactory::create_animal(HabitatType::Pond, "Donald");
        assert_eq!(animal.speak(), "Quack!");
        assert_eq!(animal.name(), "Donald");
    }

    #[test]
    fn jungle_creates_tigers() {
        let animal = OrganismFactory::create_animal(HabitatType::Jungle, "Shere Khan");
        assert_eq!(animal.speak(), "Roar!");
    }

    #[test]
    fn pond_creates_water_lilies() {
        let plant = OrganismFactory::create_plant(HabitatType::Pond, "Lily");
        assert_eq!(plant.grow(), "Grows on water surface");
    }

    #[test]
    fn habitat_populates_organisms() {
        let mut habitat = Habitat::new(HabitatType::Jungle);
        habitat.add_animal("Rajah");
        habitat.add_plant("Oak");
        assert_eq!(habitat.animals.len(), 1);
        assert_eq!(habitat.plants.len(), 1);
        assert_eq!(habitat.animals[0].speak(), "Roar!");
    }

    #[test]
    fn animal_behaviors() {
        let frog = Animal::Frog("Kermit".to_string());
        assert_eq!(frog.speak(), "Croak!");
        assert_eq!(frog.eat(), "Eats flies");
        assert_eq!(frog.sleep(), "Sleeps on lily pad");
    }
}
