//! Adapter pattern
//!
//! Adapts a BritishTextObject (using centimetres and colour)
//! to a TextObject interface (using inches and color).

pub trait TextObject {
    fn text(&self) -> String;
    fn size_inches(&self) -> f64;
    fn color(&self) -> String;
}

pub struct BritishTextObject {
    pub string: String,
    pub size_cm: f64,
    pub colour: String,
}

impl BritishTextObject {
    pub fn new(string: &str, size_cm: f64, colour: &str) -> Self {
        Self {
            string: string.to_string(),
            size_cm,
            colour: colour.to_string(),
        }
    }
}

pub struct BritishTextObjectAdapter {
    object: BritishTextObject,
}

impl BritishTextObjectAdapter {
    pub fn new(object: BritishTextObject) -> Self {
        Self { object }
    }
}

impl TextObject for BritishTextObjectAdapter {
    fn text(&self) -> String {
        self.object.string.clone()
    }

    fn size_inches(&self) -> f64 {
        self.object.size_cm / 2.54
    }

    fn color(&self) -> String {
        self.object.colour.clone()
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn adapter_returns_text() {
        let british = BritishTextObject::new("Hello World", 10.0, "red");
        let adapter = BritishTextObjectAdapter::new(british);
        assert_eq!(adapter.text(), "Hello World");
    }

    #[test]
    fn adapter_converts_cm_to_inches() {
        let british = BritishTextObject::new("Test", 2.54, "blue");
        let adapter = BritishTextObjectAdapter::new(british);
        let inches = adapter.size_inches();
        assert!((inches - 1.0).abs() < 0.001);
    }

    #[test]
    fn adapter_maps_colour_to_color() {
        let british = BritishTextObject::new("Test", 5.0, "green");
        let adapter = BritishTextObjectAdapter::new(british);
        assert_eq!(adapter.color(), "green");
    }

    #[test]
    fn adapter_converts_large_size() {
        let british = BritishTextObject::new("Big", 25.4, "black");
        let adapter = BritishTextObjectAdapter::new(british);
        assert!((adapter.size_inches() - 10.0).abs() < 0.001);
    }
}
