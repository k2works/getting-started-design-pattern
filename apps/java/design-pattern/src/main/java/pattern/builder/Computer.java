package pattern.builder;

import java.util.List;

/**
 * コンピュータ（record）。
 */
public record Computer(String display, Motherboard motherboard, List<Drive> drives) {
}
