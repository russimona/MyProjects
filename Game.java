import java.awt.*;
import java.awt.event.*;
import java.util.Random;
import javax.swing.*;


public class Game extends JPanel implements ActionListener {

	static final int SCREEN_WIDTH = 600;
	static final int SCREEN_HEIGHT = 600;
	static final int UNIT_SIZE  = 25;
	static final int GAME_UNITS = (SCREEN_WIDTH * SCREEN_HEIGHT) / UNIT_SIZE;
	static Integer DELAY = 85;

	
	final int x[] = new int[GAME_UNITS];
	final int y[] = new int[GAME_UNITS];
	int bodyParts = 6;
	int score;
	int appleX;
	int rottenAppleX;
	int appleY;
	int rottenAppleY;
	int poisonX;
	int poisonY;
	int level = 1;
	char direction = 'R';
	/// R - RIGHT
	/// L - LEFT
	/// U - UP
	/// D - DOWN
	boolean running = false;
	Timer timer;
	Random random;
	
	
	public Game() {
		random = new Random();
		this.setSize(SCREEN_HEIGHT,SCREEN_WIDTH);
		this.setLocation(100,10);
		this.setBackground(Color.BLACK);
		this.setFocusable(true);
		this.addKeyListener(new MyKeyAdapter());
		startGame();
	}
	
	public void startGame() {
		newRandomApple();
		newRandomRottenApple();
		newRandomPoison();
		running = true;
		timer = new Timer(DELAY,this);
		timer.start();
		
	}

	public void paintComponent(Graphics G) {
		super.paintComponent(G);
		draw(G);
	}
	
	public void draw(Graphics G) {
		
		if ( running ) {
			G.setColor(Color.RED);
			G.fillOval(appleX, appleY, UNIT_SIZE, UNIT_SIZE);
			
			if (score >= 5) {
				G.setColor(Color.yellow);
				G.fillOval(rottenAppleX, rottenAppleY, UNIT_SIZE, UNIT_SIZE);
			}
			
			if ( level >=3 ) {
				G.setColor(Color.white);
				G.fillOval(poisonX, poisonY, UNIT_SIZE, UNIT_SIZE);
			}
	
			for( int i = 0; i < bodyParts; i++) {
				if ( i == 0 ) {
					G.setColor(Color.GREEN);
					G.fillRect(x[i], y[i], UNIT_SIZE, UNIT_SIZE);
				}else {
					//G.setColor(new Color(45,180,0));
					G.setColor(new Color(random.nextInt(255),random.nextInt(255),random.nextInt(255)));
					G.fillRect(x[i], y[i], UNIT_SIZE, UNIT_SIZE);
				}
			}
			
			G.setColor(Color.CYAN);
			G.setFont(new Font("Ink Free", Font.BOLD, 35));
			FontMetrics metrics = getFontMetrics(G.getFont());
			G.drawString("Score : " + score , 4 * UNIT_SIZE, G.getFont().getSize());
			
			G.setColor(Color.CYAN);
			G.setFont(new Font("Ink Free", Font.BOLD, 35));
			FontMetrics metrics1 = getFontMetrics(G.getFont());
			G.drawString("Level " + level , (metrics.stringWidth("Score : " + level)) + 8 * UNIT_SIZE, G.getFont().getSize());
			
		}else {
			gameOver(G);
		}
		
	}
	
	public void newRandomApple() {
		appleX = random.nextInt((int)(SCREEN_WIDTH/UNIT_SIZE)) * UNIT_SIZE;
		appleY = random.nextInt((int)(SCREEN_HEIGHT/UNIT_SIZE)) * UNIT_SIZE;
	}
	
	public void newRandomRottenApple() {
		rottenAppleX = random.nextInt((int)(SCREEN_WIDTH/UNIT_SIZE)) * UNIT_SIZE;
		while ( appleX  == rottenAppleY ) {
			rottenAppleX = random.nextInt((int)(SCREEN_WIDTH/UNIT_SIZE)) * UNIT_SIZE;
		}
		rottenAppleY = random.nextInt((int)(SCREEN_HEIGHT/UNIT_SIZE)) * UNIT_SIZE;
		while ( appleY  == rottenAppleY ) {
			rottenAppleY = random.nextInt((int)(SCREEN_HEIGHT/UNIT_SIZE)) * UNIT_SIZE;
		}
		
	}
	
	public void newRandomPoison() {
		poisonX = random.nextInt((int)(SCREEN_WIDTH/UNIT_SIZE)) * UNIT_SIZE;
		while ( poisonX == rottenAppleY || poisonX == appleX) {
			poisonX = random.nextInt((int)(SCREEN_WIDTH/UNIT_SIZE)) * UNIT_SIZE;
		}
		poisonY = random.nextInt((int)(SCREEN_HEIGHT/UNIT_SIZE)) * UNIT_SIZE;
		while ( poisonY == rottenAppleY || poisonY == appleY) {
			poisonY = random.nextInt((int)(SCREEN_WIDTH/UNIT_SIZE)) * UNIT_SIZE;
		}
	}
	
	public void move() {
		for(int i = bodyParts; i > 0; i --) {
			x[i] = x[i-1];
			y[i] = y[i-1];
		}
		
		switch(direction){
		case 'U' : 
			if ( y[0] <= 0) {
				y[0] = SCREEN_WIDTH;
			}else {

				y[0] = (y[0] - UNIT_SIZE);
			}
			break;
		case 'D' :
			y[0] = (y[0] + UNIT_SIZE)%SCREEN_WIDTH;
			break;
		case 'L' :
			if ( x[0] <= 0) {
				x[0] = SCREEN_WIDTH-25;
			}else {

				x[0] = x[0] - UNIT_SIZE;
			}
			break;
		case 'R' :
			x[0] = (x[0] + UNIT_SIZE)%SCREEN_WIDTH;
			break;
		}
		
	
	}
	
	public void checkSnakeEat() {
		if ((x[0] == appleX ) && (y[0] == appleY) ) {
			bodyParts  ++;
			score ++;
			newRandomApple();
			//level = 1;
		}
	
			
		if ((x[0] == rottenAppleX ) && (y[0] == rottenAppleY) ) {
			bodyParts--;
			score--;
			newRandomRottenApple();
		}
		
		if ((x[0] == poisonX ) && (y[0] == poisonY) ) {
			bodyParts=3;
			score=0;
			newRandomRottenApple();
		}
		
	 
	
	}
	
	public void checkSnakeDies() {
		
		/// verifica daca sarpele se musca
		for(int i= bodyParts; i> 0 ; i-- ) {
			if ( (x[0] == x[i]) && (y[0] == y[i] )) {
				running = false;
			}
		}
				
		/// scorul nu poate fi negativ
		if ( score < 0  ) {
			running = false;
		}
	
		if ( !running) {
			timer.stop();
		}
	}
	
	public void checkLevelGame() {
		if ( 0 <= score && score < 5) {
			level = 1;
			timer.setDelay(DELAY);
		}
		
		if ( 5 <= score && score < 10) {
			level = 2;
			timer.setDelay(65);
		}
		
		if ( 10 <= score && score < 15) {
			level = 3;
			timer.setDelay(55);
		}
		
		if ( 15 <= score && score < GAME_UNITS) {
			level = 4;
			timer.setDelay(45);
		}
		
	}
	
	public void gameOver(Graphics G) {
		G.setColor(Color.cyan);
		G.setFont(new Font("Ink Free", Font.BOLD, 75));
		FontMetrics metrics = getFontMetrics(G.getFont());
		G.drawString("Game Over", (SCREEN_WIDTH - metrics.stringWidth("Game Over"))/2, SCREEN_HEIGHT/2);
		
		G.setColor(Color.CYAN);
		G.setFont(new Font("Ink Free", Font.BOLD, 35));
		FontMetrics metrics2 = getFontMetrics(G.getFont());
		G.drawString("Score : " + score , 4 * UNIT_SIZE, G.getFont().getSize());
		
		
		G.setColor(Color.CYAN);
		G.setFont(new Font("Ink Free", Font.BOLD, 35));
		FontMetrics metrics3 = getFontMetrics(G.getFont());
		G.drawString("Level " + level , (metrics2.stringWidth("Score : " + level)) + 8 * UNIT_SIZE, G.getFont().getSize());
	}
	
	@Override
	public void actionPerformed(ActionEvent e) {
		if ( running ) {
			move();
			checkSnakeEat();
			checkSnakeDies();
		}
		checkLevelGame();
		repaint();
	}
	

	public class MyKeyAdapter extends KeyAdapter{
		@Override
		public void keyPressed(KeyEvent e) {
			switch(e.getKeyCode()) {
			case KeyEvent.VK_LEFT:
				if ( direction != 'R') {
					direction = 'L';
				}
				break;
			case KeyEvent.VK_RIGHT:
				if ( direction != 'L') {
					direction = 'R';
				}
				break;
			case KeyEvent.VK_UP:
				if ( direction != 'D') {
					direction = 'U';
				}
				break;
			case KeyEvent.VK_DOWN:
				if ( direction != 'U') {
					direction = 'D';
				}
				break;
			}
		}
	}

}
