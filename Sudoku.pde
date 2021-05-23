class Sudoku extends MiniGame{

  int size = 9;
  int[][] solution = new int[size][size];
  int[][] current = new int[size][size];
  
  String originaPath = "Sudoku/Original.txt";
  String solvedPath = "Sudoku/Solved.txt";
  
  Piece[][] board = new Piece[size][size];
  Piece selected;
  
  int index;
  
  int aciertos = 0, fallos = 0; //TIEMPO
  
  boolean success;
  
  
  Sudoku(String gameName){
    this.gameName = gameName;
  
  }
  
  
  void display(){
    if(start){
      if (timerFinished){
        inGame();
      } else {
        countDown();
      }
    } else {
      howToPlay();
    }
  }
  
  
  void howToPlay(){
    pushMatrix();
    fill(0);
    textSize(50);
    text("PRESIONA ENTER PARA COMENZAR",15,300);
    popMatrix();
  }
  
  void inGame(){
    printBoard();
    printText();
  }
  
  void printBoard(){
    for (int i = 0 ; i < size; i++) {
      for (int j = 0; j < size; j++){
        board[i][j].display();
      }
    }
  }
  
  void printText(){
    pushMatrix();
    textSize(40);
    fill(255,0,0);
    text("Fallos: "+fallos, 20,65);
    fill(0,255,0);
    text("Aciertos: "+aciertos, 210,65);
    fill(0,0,255);
    text("Puntuación: "+score, 570,65);
    popMatrix();
    
  }
  
  void control(int keyPress){
    if(keyPress == ENTER){
      millis = millis();
      start = true;
      loadSolution();
      loadCurrent();
      createBoard();
    } 
    if (keyPress <= 57 && keyPress >= 49){
      try{
        switch(keyPress){
        case 49:
          selected.setValue(1);
          println(1);
          break;
        case 50:
          selected.setValue(2);
          println(2);
          break;
        case 51:
          selected.setValue(3);
          println(3);
          break;
        case 52:
          selected.setValue(4);
          println(4);
          break;
        case 53:
          selected.setValue(5);
          println(5);
          break;
        case 54:
          selected.setValue(6);
          println(6);
          break;
        case 55:
          selected.setValue(7);
          println(7);
          break;
        case 56:
          selected.setValue(8);
          println(8);
          break;
        case 57:
          selected.setValue(9);
          println(9);
          break;
        }
        success = selected.getPieceEnded();
        if(success){
          aciertos++;
        } else {
          fallos++;
        }
      } catch(NullPointerException e){}
    }
  }
  
  void control(int x, int y, boolean left){
    if(start){
      if(left){
        checkPosition(x, y);   
      }
    }
  }


  void checkPosition(int x, int y){
    for(int i = 0; i < size; i++){
      for(int j = 0; j < size; j++){
        if(board[i][j].isInArea(x, y)){
          if (selected != null){
            selected.isNotClicked();
          }
          selected = board[i][j];
          break;
        }
      }  
    }
  }


  
  void loadSolution(){
    String[] lines = loadStrings(originaPath);
    index = (int)(random(1, Integer.parseInt(lines[0].substring(0, lines[0].indexOf(";")))));
    
    int posI = 0;
    int start = 2+(index-1)*10;
    println("Solucion:");
    for (int i = start ; i < start+9; i++) {
      for (int j = 0; j < 9; j++){
        solution[posI][j] = Character.getNumericValue(lines[i].charAt(j));
        print(solution[posI][j]);
      }
      println();
      posI++;
    }
  }
  
  void loadCurrent(){
    String[] lines = loadStrings(solvedPath);
    
    int posI = 0;
    int start = 2+(index-1)*10;
    println("Original:");
    for (int i = start ; i < start+9; i++) {
      for (int j = 0; j < 9; j++){
        if(lines[i].charAt(j) == '.'){
          current[posI][j] = -1;
        } else { current[posI][j] = Character.getNumericValue(lines[i].charAt(j));}
        print(current[posI][j]);
      }
      println();
      posI++;
    }
  
  }
  
  void createBoard(){
    for (int i = 0 ; i < 9; i++) {
      for (int j = 0; j < 9; j++){
        board[i][j] = new Piece(0+j*100,90+i*70,100,70,current[i][j],solution[i][j]);
      }
    }
  }
}










class Piece{
  int x, y, xWidth, yHeight, v, solution;
  boolean pieceEnded=false, isClicked = false;
  
  Piece(int x, int y, int xWidth, int yHeight, int v, int solution){
    this.x = x;
    this.y = y;
    this.xWidth = xWidth;
    this.yHeight = yHeight;
    this.v = v;
    this.solution = solution;
  }
  
  
  
  
  void display(){
    noFill();
    strokeWeight(5);
    textSize(50);
    rect(x, y, xWidth, yHeight);
    if(pieceEnded){
      fill(0,255,0);
      text(""+v,x+0.35*xWidth,y+0.75*yHeight);
    } else {
      if (isClicked){
        line(x+5,y+0.85*yHeight,x+xWidth-5,y+0.85*yHeight);
      }
      if(v == -1){
        // Sin numero
      } else{
        if (v != solution){
          // Numero mal
          fill(255,0,0);
          text(""+v,x+0.35*xWidth,y+0.75*yHeight);
        } else {
          //numero bien
          pieceEnded = true;
        }
      }
    }
  }
  
  boolean isInArea(int xMouse, int yMouse){
    if(!pieceEnded){
      if ((xMouse>x && xMouse<x+xWidth) && (yMouse>y && yMouse<y+yHeight)){
        isClicked = true;
        return true;
      }
    }
    return false;
  }
  
  void isNotClicked(){
    isClicked = false;
  }
  
  void setValue(int v){
    if (!pieceEnded){
      this.v = v;
    }
  }
  
  boolean getPieceEnded(){
    return v == solution;
  }
}
