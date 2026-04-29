package pattern.interpreter;

import java.nio.file.Path;
import java.util.ArrayList;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;

/**
 * OR 複合式。いずれかの式に一致するファイルを返す（重複なし）。
 */
public class OrExpression implements Expression {
    private final Expression left;
    private final Expression right;

    public OrExpression(Expression left, Expression right) {
        this.left = left;
        this.right = right;
    }

    @Override
    public List<Path> evaluate(Path dir) {
        Set<Path> result = new LinkedHashSet<>(left.evaluate(dir));
        result.addAll(right.evaluate(dir));
        return new ArrayList<>(result);
    }
}
