import de.bezier.guido.*;
private int NUM_ROWS = 10;
private int NUM_COLS = 10;
private MSButton[][] buttons = new MSButton[NUM_ROWS][NUM_COLS]; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList<MSButton>(); //ArrayList of just the minesweeper buttons that are mined
private boolean lost = false;

void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    //your code to initialize buttons goes here
    for (int i = 0; i < NUM_ROWS; i++){
      for (int x = 0; x < NUM_COLS; x++){
        buttons[i][x] = new MSButton(i, x);
      }
    }
    
    
    setMines();
}
public void setMines()
{
  while (mines.size() < 20){
    int randomr = (int)(Math.random()*NUM_ROWS);
    int randomc = (int)(Math.random()*NUM_COLS);
    MSButton e = buttons[randomr][randomc];
    if (!mines.contains(e)){
      mines.add(e);
    }
  }
}

public void draw ()
{
    background( 0 );
    
}
public boolean isWon() {
    for (int i = 0; i < NUM_ROWS; i++) {
        for (int j = 0; j < NUM_COLS; j++) {
            MSButton button = buttons[i][j];
            if (!button.clicked && !mines.contains(button)) {
                return false;
            }
            if (button.flagged && !mines.contains(button)) {
                return false;
            }
        }
    }
    return true;
}

public void displayLosingMessage()
{
    textSize(50);
    fill(255, 0, 0);
    text("You Lose...", 200, 200);
}
public void displayWinningMessage()
{
    textSize(50);
    fill(0, 255, 0);
    text("You Win!", 200, 200);
}
public boolean isValid(int r, int c)
{
    if (r >= 0 && r < NUM_ROWS && c >= 0 && c < NUM_COLS){
      return true;
    }
    return false;
}
public int countMines(int row, int col)
{
    int numMines = 0;
    for (int i = row-1; i <= row+1; i++){
      for (int x = col-1; x <= col+1; x++){
        if (isValid(i, x) && mines.contains(buttons[i][x])) {
          numMines++;
        }
      }
    }
    return numMines;
}
public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
    
    public MSButton ( int row, int col )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        myRow = row;
        myCol = col; 
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add( this ); // register it with the manager
    }

    // called by manager
    public void mousePressed () {   
      clicked = true;
      if (mouseButton == RIGHT) {
          if (!flagged) {
              flagged = true;
          } else {
              flagged = false;
              clicked = false;
          }
      } else if (mines.contains(this)) {
          lost = true;
      } else if (countMines(myRow, myCol) > 0) {
          myLabel = String.valueOf(countMines(myRow, myCol));
      } else {
          for (int i = myRow - 1; i <= myRow + 1; i++) {
              for (int x = myCol - 1; x <= myCol + 1; x++) {
                  if (isValid(i, x)) {
                      MSButton neighborButton = buttons[i][x];
                      if (!neighborButton.clicked && !neighborButton.flagged) {
                          neighborButton.mousePressed();
                      }
                  }
              }
          }
      }
  }

    public void draw () 
    {    
        if (flagged)
            fill(0);
        else if( clicked && mines.contains(this) ) 
             fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );
        textSize(20);
        rect(x, y, width, height);
        fill(0);
        text(myLabel,x+width/2,y+height/2);
        if(isWon() == true)
          displayWinningMessage();
        if(lost == true){
          displayLosingMessage();
      }
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
}
