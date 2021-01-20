import java.awt.Color;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.SwingUtilities;

public class GameFrame extends JFrame implements ActionListener{
	Game game;
	JButton resetButton;
	static final int SCREEN_WIDTH = 700;
	static final int SCREEN_HEIGHT = 700;
	
	public GameFrame() {
		this.setTitle("Snake");
		this.setResizable(false);
		this.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		this.setSize(SCREEN_WIDTH+200, SCREEN_HEIGHT);
		this.setLayout(null);
		
		resetButton = new JButton();
		resetButton.setText("Play Again");
		resetButton.setSize(100, 50);
		resetButton.setBackground(Color.LIGHT_GRAY);
		resetButton.setLocation(SCREEN_WIDTH, SCREEN_HEIGHT/2-50);
		resetButton.addActionListener(this);
		
		game = new Game();
		
		
		this.add(resetButton);
		this.add(game);
	
		this.setVisible(true);
	}

	@Override
	public void actionPerformed(ActionEvent e) {
		// TODO Auto-generated method stub
		if ( e.getSource() == resetButton ) {
			this.remove(game);
			game = new Game();
			this.add(game);
			game.requestFocusInWindow();
			SwingUtilities.updateComponentTreeUI(this);
		}
	}

}
