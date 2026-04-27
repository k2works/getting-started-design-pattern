package pattern.interpreter;

import java.nio.file.Path;
import java.util.ArrayList;
import java.util.List;

/**
 * AND 複合式。両方の式に一致するファイルを返す。
 */
public class AndExpression implements Expression {
    private final Expression left;
    private final Expression right;

    public AndExpression(Expression left, Expression right) {
        this.left = left;
        this.right = right;
    }

    @Override
    public List<Path> evaluate(Path dir) {
        List<Path> leftResult = left.evaluate(dir);
        List<Path> rightResult = right.evaluate(dir);
        List<Path> result = new ArrayList<>(leftResult);
        result.retainAll(rightResult);
        return result;
    }
}
