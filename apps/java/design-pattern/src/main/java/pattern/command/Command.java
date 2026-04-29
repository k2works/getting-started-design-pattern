package pattern.command;

/**
 * コマンドインターフェース（Command パターン）。
 * 操作の実行と取り消しを統一的に扱う。
 */
public interface Command {
    void execute();

    void unexecute();

    String getDescription();
}
