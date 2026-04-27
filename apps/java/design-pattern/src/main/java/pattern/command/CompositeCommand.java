package pattern.command;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

/**
 * 複合コマンド。
 * 複数のコマンドをまとめて実行・取り消しする。
 */
public class CompositeCommand implements Command {
    private final List<Command> commands = new ArrayList<>();

    public void addCommand(Command cmd) {
        commands.add(cmd);
    }

    @Override
    public void execute() {
        commands.forEach(Command::execute);
    }

    @Override
    public void unexecute() {
        List<Command> reversed = new ArrayList<>(commands);
        Collections.reverse(reversed);
        reversed.forEach(Command::unexecute);
    }

    @Override
    public String getDescription() {
        return commands.stream()
                .map(Command::getDescription)
                .collect(Collectors.joining("\n")) + "\n";
    }
}
