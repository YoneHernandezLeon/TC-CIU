int numberOfGames = 3, index = 0;

MiniGame[] gameList = new MiniGame[numberOfGames];

boolean inGame = false;
boolean userLogged = false;

String userName = "";

void setup(){
  size(1280,720);
  stroke(15);
  
  
  gameList[0] = new Sudoku("Sudoku");
  gameList[1] = new Memory("Memory");
  gameList[2] = new CoinChange("Coins");
}

void draw(){
  if(userLogged){
    background(125);
    line(900,0,900,720);
    
    if (inGame){
      gameList[index].display();
    } else {
      displayMenu();
    }
  } else{
    displayLogin();
  }
   
}

void displayMenu(){
  
  
  textSize(30);
  fill(0);
  for(int i = 0; i < numberOfGames; i++){
    text(gameList[i].getGameName(),400,300+40*i);
  }
  displayBox();
  
}

void displayLogin(){
  background(0);
  textSize(25);
  text("Escribe el nombre de usuario",400,300);
  text(userName, 400,340);
}

void displayBox(){
  noFill();
  strokeWeight(5);
  rect(390,265+index*40,150,45);

}

void keyPressed(){
  if(userLogged){
  if (inGame){ 
    gameList[index].control(key);
  }
  if (key == ENTER){
    inGame = true;
  }
  if(key == BACKSPACE){
    inGame = false;
  }
  
  
  if (keyCode == DOWN){
    if(index == numberOfGames-1){
      index = 0;
    } else {
      index++;
    }
  }
  if (keyCode == UP){
    if(index == 0){
      index = numberOfGames-1;
    } else {
      index--;
    }
  }
  } else {
    if(keyCode == ENTER){
      userLogged = true;
      //Llamadas a crear o comprobar usuario 
    }
    
    if(key == BACKSPACE && userName.length() > 0){
      userName = userName.substring(0, userName.length()-1);
    } else {
      userName += key;
    }
  } 
  
}

void mousePressed(){
  gameList[index].control(mouseX, mouseY, (mouseButton ==  LEFT));
}
