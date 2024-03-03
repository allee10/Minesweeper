import de.bezier.guido.*;
//Declare and initialize constants NUM_ROWS and NUM_COLS = 20
int NUM_ROWS = 20;
int NUM_COLS = 20;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines; //ArrayList of just the minesweeper buttons that are mined
int numMines = 29;
int numFlagged = 0;
int numClicked = 0;

void setup ()
{
  size(800, 800);
  textSize(14);
  textAlign(CENTER, CENTER);

  // make the manager
  Interactive.make( this );

  //your code to initialize buttons goes here
  buttons = new MSButton[NUM_ROWS][NUM_COLS];
  mines = new ArrayList <MSButton>();
  for (int i = 0; i<NUM_ROWS; i++) {
    for (int j = 0; j<NUM_COLS; j++)
      buttons[i][j] = new MSButton(i, j);
  }
  setMines();
}
public void setMines()
{
  for (int i = 0; i<numMines; i++) {
    int i1 = (int)(Math.random()*NUM_ROWS);
    int j1 = (int)(Math.random()*NUM_COLS);
    if (mines.contains(buttons[i1][j1])==false)
      mines.add(buttons[i1][j1]);
    else
      i--;
  }
}

public void draw ()
{
  background( 0 );
    for (int i = 0; i < NUM_ROWS; i++) {
      for (int j = 0; j < NUM_COLS; j++) {
        buttons[i][j].draw();
      }
    }
}
public boolean isWon()
{
  return ((NUM_ROWS*NUM_COLS)-mines.size()==numClicked);
}
public void displayLosingMessage()
{
  for (int i = 0; i < NUM_ROWS; i++) {
      for (int j = 0; j < NUM_COLS; j++) {
        buttons[i][j].click();
      }
    }
  frameRate(7);
  text("womp womp :(", (float)Math.random()*800,(float)Math.random()*800);
}
public void displayWinningMessage()
{
  frameRate(7);
   text("yippee!!", (float)Math.random()*800,(float)Math.random()*800);
}
public boolean isValid(int r, int c) {
  if (r<NUM_ROWS&&c<NUM_COLS&&r>-1&&c>-1)
    return true;
  return false;
}
public int countMines(int row, int col)
{
  int n = 0;
  for (int i = 0; i<NUM_ROWS; i++) {
    for (int j = 0; j<NUM_COLS; j++) {
      if (isValid(i, j)) {
        if (row==i&&j==col) {
        } else if (i>=row-1&&i<=row+1&&j>=col-1&&j<=col+1&&mines.contains(buttons[i][j])) {
          n++;
        }
      }
    }
  }
  return n;
}
public class MSButton
{
  private int myRow, myCol;
  private float x, y, width, height;
  private boolean clicked, flagged;
  private String myLabel;

  public MSButton ( int row, int col )
  {
    width = 800/NUM_COLS;
    height = 800/NUM_ROWS;
    myRow = row;
    myCol = col;
    x = myCol*width;
    y = myRow*height;
    myLabel = "";
    flagged = clicked = false;
    Interactive.add( this ); // register it with the manager
  }

  // called by manager
  public void mousePressed ()
  {
    if (mouseButton == RIGHT) {
      flagged = !flagged;
      numFlagged++;
    } else if (mines.contains(this)&&clicked) {
      displayLosingMessage();
    } else if (countMines(myRow, myCol) > 0) {
      if (!clicked) {
        numClicked++;
      }
      clicked = true;
    } else {

      if (!clicked) {
        numClicked++;
      }
      clicked = true;
      if (isValid(myRow+1, myCol+1)&&!buttons[myRow+1][myCol+1].clicked&&!mines.contains(buttons[myRow+1][myCol+1]))
        buttons[myRow+1][myCol+1].mousePressed();
      if (isValid(myRow+1, myCol)&&!buttons[myRow+1][myCol].clicked&&!mines.contains(buttons[myRow+1][myCol]))
        buttons[myRow+1][myCol].mousePressed();
      if (isValid(myRow+1, myCol-1)&&!buttons[myRow+1][myCol-1].clicked&&!mines.contains(buttons[myRow+1][myCol-1]))
        buttons[myRow+1][myCol-1].mousePressed();
      if (isValid(myRow, myCol+1)&&!buttons[myRow][myCol+1].clicked&&!mines.contains(buttons[myRow][myCol+1]))
        buttons[myRow][myCol+1].mousePressed();
      if (isValid(myRow, myCol-1)&&!buttons[myRow][myCol-1].clicked&&!mines.contains(buttons[myRow][myCol-1]))
        buttons[myRow][myCol-1].mousePressed();
      if (isValid(myRow-1, myCol+1)&&!buttons[myRow-1][myCol+1].clicked&&!mines.contains(buttons[myRow-1][myCol+1]))
        buttons[myRow-1][myCol+1].mousePressed();
      if (isValid(myRow-1, myCol)&&!buttons[myRow-1][myCol].clicked&&!mines.contains(buttons[myRow-1][myCol]))
        buttons[myRow-1][myCol].mousePressed();
      if (isValid(myRow-1, myCol-1)&&!buttons[myRow-1][myCol-1].clicked&&!mines.contains(buttons[myRow-1][myCol-1]))
        buttons[myRow-1][myCol-1].mousePressed();
    }
  }
  public void draw ()
  {    
    if (flagged) {
      fill(69, 59, 122);
    } else if (!flagged && clicked && mines.contains(this)) {
      fill(255, 0, 0);
      displayLosingMessage();
    } else if ( flagged && mines.contains(this) ) {
      fill(175, 237, 177);
    } else if (clicked) {
      fill(175, 217, 237);
      if (countMines(myRow, myCol)>0)
        this.setLabel(countMines(myRow, myCol));
    } else {
      fill(175, 237, 177);
    }
      if (isWon()){
      displayWinningMessage();}
    rect(x, y, width, height);
    fill(69, 59, 122);
    text(myLabel, x+width/2, y+height/2);
  }
  public void setLabel(String newLabel)
  {
    myLabel = newLabel;
  }
  public void setLabel(int newLabel)
  {
    myLabel = ""+ newLabel;
  }
  public boolean isFlagged()
  {
    return flagged;
  }
  public void click()
  {
    this.clicked=true;
  }
}
