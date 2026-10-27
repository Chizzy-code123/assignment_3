/*
  Chizzy
 I'm making a block breaker type game that I saw on google
 
 The mechanics in this game will be
 - Moving paddle that can hit the moving ball
 - Rectangles that will increase the player's score if hit
 - Score
 - Retry button
 
 */

// References

// Variables
boolean roundStarted = false;
boolean ballInPlay = false;

boolean leftPressed = false;
boolean rightPressed = false;

// Buttons
int startButtonX = 125, startButtonY = 340, startButtonWidth = 350, startButtonHeight = 100;
int paddleX = 200, paddleY = 480, paddleWidth = 150, paddleHeight = 15;

// Bouncing ball
int ballX = paddleX + paddleWidth / 2, ballY = paddleY - 25, ballRadius = 25;

// Blocks
int blockX, blockY, blockWidth = 75, blockHeight = 20, blockRadius = 10;

// Configurations
int screenWidth = 600, screenHeight = 600;
int paddleSpeed = 10;
float ballSpeedX = 4, ballSpeedY = 4;

void setup() {
  size(600, 600);
  background(20);
}

// Handles ball movement and collision
void updateBall() {
  ballX += ballSpeedX;
  ballY += ballSpeedY;

  if (ballX - ballRadius < 0) {
    ballX = ballRadius;
    ballSpeedX *= -1;
  }
  if (ballX + ballRadius > screenWidth) {
    ballX = screenWidth - ballRadius;
    ballSpeedX *= -1;
  }

  if (ballY - ballRadius < 0) {
    ballY = ballRadius;
    ballSpeedY *= -1;
  }

  // Ball and paddle collision
  if (ballX >= paddleX && ballX <= paddleX + paddleWidth &&
    ballY + ballRadius >= paddleY && ballY <= paddleY + paddleHeight && ballSpeedY > 0) {

    float paddleCenterX = paddleX + (paddleWidth / 2.0);
    float hitOffset = ballX - paddleCenterX;
    float normalizedHit = hitOffset / (paddleWidth / 2.0);

    // Set horizontal speed based on hit location (Outer edges = sharper angle)
    float maxHorizontalSpeed = 6.0;
    ballSpeedX = normalizedHit * maxHorizontalSpeed;

    // Force vertical speed to bounce UP
    float upwardSpeed = 4.5;
    ballSpeedY = -upwardSpeed;

    ballY = paddleY - ballRadius;
  }

  // 4. Bottom wall (Lose life / Reset)
  if (ballY + ballRadius > screenHeight) {
    println("Ball past the screen height!");
    //resetBall();
  }
}

void draw() {
  // Title
  textSize(64);
  fill(255);
  text("Block Breaker", 125, 100);

  rect(startButtonX, startButtonY, startButtonWidth, startButtonHeight, 15);
  textSize(55);
  fill(0);
  text("Start", 235, 410);

  // Starting the game
  if (roundStarted) {
    background(20);

    // Create the paddle
    fill(255);
    rect(paddleX, paddleY, paddleWidth, paddleHeight, 15);

    // Create the ball
    circle(ballX, ballY, ballRadius);
  }

  // Paddle movement
  if (rightPressed && paddleX < screenWidth - paddleWidth) {
    paddleX += paddleSpeed;
  }

  if (leftPressed && paddleX > 0) {
    paddleX -= paddleSpeed;
  }

  if (roundStarted) {
    updateBall();
  }
}

// Paddle movement
void keyPressed() {

  // Move the paddle right
  if (key == 'd' || key == RIGHT) {
    rightPressed = true;
  } else if (key == 'a' || key == LEFT) {
    // Move it left
    leftPressed = true;
    println(leftPressed);
  }
}

void keyReleased() {
  if (key == 'a' || key == LEFT) {
    leftPressed = false;
  } else if (key == 'd' || key == RIGHT) {
    rightPressed = false;
  }
}

void mousePressed() {
  if (roundStarted) {
    return;
  }
  if (mouseX >= startButtonX &&
    mouseX <= startButtonX + startButtonWidth &&
    mouseY >= startButtonY &&
    mouseY <= startButtonY + startButtonHeight) {
    println("Player pressed the start button");
    roundStarted = true;
  }
}

