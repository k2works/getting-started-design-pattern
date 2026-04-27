package pattern.interpreter;

import java.nio.file.Path;
import java.util.ArrayList;
import java.util.List;

/**
 * NOT 式。指定の式に一致しないファイルを返す。
 */
public class NotExpression implements Expression {
    private final Expression expression;

    public NotExpression(Expression expression) {
        this.expression = expression;
    }

    @Override
    public List<Path> evaluate(Path dir) {
        List<Path> all = new AllExpression().evaluate(dir);
        List<Path> excluded = expression.evaluate(dir);
        List<Path> result = new ArrayList<>(all);
        result.removeAll(excluded);
        return result;
    }
}
