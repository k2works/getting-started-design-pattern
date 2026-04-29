package pattern.command;

/**
 * ラムダベースのボタン（Java らしい Command）。
 * Runnable をコマンドとして受け取り、ボタン押下時に実行する。
 */
public class SlickButton {
    private final Runnable command;

    public SlickButton(Runnable command) {
        this.command = command;
    }

    public void onButtonPush() {
        if (command != null) {
            command.run();
        }
    }
}
