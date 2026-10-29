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
int startBlockX = 40, startBlockY = 40;
int blockX = startBlockX, blockY = startBlockY, blockWidth = 75, blockHeight = 20, blockRadius = 10;
boolean blocksLoaded = false;

// Configurations
int screenWidth = 600, screenHeight = 600;
int paddleSpeed = 10;
float ballSpeedX = 4, ballSpeedY = 4;

int blockMaxCount = 28;
int blockRows = 4;
int blockColumns = 7;
int blockSpacingX = 75, blockSpacingY = 20;
int blockCount;

boolean[] blockAlive = new boolean[28];

void setup() {
  size(600, 600);
  background(20);

  for (int i = 0; i < blockMaxCount; i++) {
    blockAlive[i] = true;
  }
}

// Handles ball movement and collision
void updateBall() {
  // Moving the ball
  ballX += ballSpeedX;
  ballY += ballSpeedY;

  // Ball hitting the left wall
  if (ballX - ballRadius < 0) {
    ballX = ballRadius;
    ballSpeedX *= -1;
  }

  // Ball hitting the right wall
  if (ballX + ballRadius > screenWidth) {
    ballX = screenWidth - ballRadius;
    ballSpeedX *= -1;
  }

  // Hitting the top
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

    float maxHorizontalSpeed = 6.0;
    ballSpeedX = normalizedHit * maxHorizontalSpeed;

    float upwardSpeed = 4.5;
    ballSpeedY = -upwardSpeed;

    ballY = paddleY - ballRadius;
  }

  if (ballY + ballRadius > screenHeight) {
    resetBall();
  }
}

void resetBall() {
  paddleX = 200;
  paddleY = 480;

  ballX = paddleX + paddleWidth / 2;
  ballY = paddleY - 25;
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
  // Starting the game
  if (roundStarted) {
    background(20);
    // Create the paddle
    fill(255);
    rect(paddleX, paddleY, paddleWidth, paddleHeight, 15);

    // Create the ball
    circle(ballX, ballY, ballRadius);

    // Load the blocks
    for (int i = 0; i <= blockMaxCount - 1; i++) {

      int col = i % blockColumns;
      int row = i / blockColumns;

      int x = 40 + col * blockSpacingX;
      int y = 40 + row * (blockHeight + 10);

      fill(210, 198, 45);

      if (i > 0 && i < 7) {
        fill(210, 198, 45);
      } else if (i > 0 && i < 14) {
        fill(0, 133, 18);
      } else if (i > 0 && i < 21) {
        fill(255, 59, 59);
      } else if (i > 0 && i < 28) {
        fill(42, 128, 209);
      }

      rect(
        x,
        y,
        blockWidth,
        blockHeight,
        10
        );

      // Collision with the ball
      if (
        ballX + ballRadius > x &&
        ballX - ballRadius < x + blockWidth &&
        ballY + ballRadius > y &&
        ballY - ballRadius < y + blockHeight
        ) {

        // Bounce the ball
        ballSpeedY = -ballSpeedY;

        // Destroy the block
        blockAlive[i] = false;

        // Stop checking blocks for this frame
        break;
      }
    }
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
    roundStarted = true;
  }
}
