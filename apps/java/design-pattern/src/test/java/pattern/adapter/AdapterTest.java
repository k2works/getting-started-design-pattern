package pattern.adapter;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

class AdapterTest {

    @Test
    void textObjectHoldsTextSizeAndColor() {
        TextObject obj = new TextObject("Hello", 2.0, "red");

        assertEquals("Hello", obj.getText());
        assertEquals(2.0, obj.getSizeInches());
        assertEquals("red", obj.getColor());
    }

    @Test
    void adapterConvertsBritishTextObjectToTextObject() {
        BritishTextObject bto = new BritishTextObject("Cheerio", 25.4, "grey");
        TextObject adapted = new BritishTextObjectAdapter(bto);

        assertEquals("Cheerio", adapted.getText());
        assertEquals(1.0, adapted.getSizeInches(), 0.001);
        assertEquals("grey", adapted.getColor());
    }

    @Test
    void rendererWorksWithAdaptedObject() {
        BritishTextObject bto = new BritishTextObject("Hello", 50.8, "blue");
        TextObject adapted = new BritishTextObjectAdapter(bto);
        Renderer renderer = new Renderer();

        String output = renderer.render(adapted);

        assertEquals("text:Hello size:2.0 color:blue", output);
    }

    @Test
    void rendererWorksWithNativeTextObject() {
        TextObject obj = new TextObject("Native", 3.5, "green");
        Renderer renderer = new Renderer();

        String output = renderer.render(obj);

        assertEquals("text:Native size:3.5 color:green", output);
    }
}
