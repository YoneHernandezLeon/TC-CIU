int numberOfGames = 3, menuIndex = 0, menuMinigamesIndex = 0, menuOptionsIndex= 0, menuUserIndex = 0;
int menuSelected = -1;
/*
-1 = Menu principal
0  = Menu minijuegos
1  = Menu de editar usuario
2  = Menu de cambiar usuario
3  = Menu de opciones
4  = Salir
*/

MiniGame[] gameList = new MiniGame[numberOfGames];
int[] gameScore = new int[numberOfGames];

boolean userLogged = false;
boolean inGame = false;
String userName = "";

void setup(){
  size(1280,720);
  stroke(15);
  
  gameList[0] = new Sudoku("Sudoku");
  gameList[1] = new Memory("Memory", new Pulse(this));
  gameList[2] = new CoinChange("Coins");
}

void draw(){
  background(255);
  textAlign(LEFT);
  if(userLogged){
    displayRightPanel();
    if(!inGame){
      displayTitle();
      switch(menuSelected){
        case -1:
        displayMainMenu();
        break;
        case 0:
        displayMinigames();
        break;
        case 1:
        displayEditUser();
        break;
        case 2:
        //resetear usuario
        changeUser();
        break;
        case 3:
        displayOptions();
        break;
        case 4:
        displayCredits();
        break;
        case 5:
        exit();
        break;
      }
    } else {
      gameList[menuMinigamesIndex].display();
    }
  } else {
    displayLogin();
  }
  
}


/*

------------------------------------- DISPLAYS COMUNES -------------------------------------

*/

void displayRightPanel(){
  stroke(0);
  line(900,0,900,720);
  displayControlBox();
  displayUser();
}

void displayControlBox(){
  pushMatrix();
  noFill();
  rect(910,20,350,290);
  
  popMatrix();
}

void displayUser(){
  pushMatrix();
  noFill();
  rect(910,320,350,350);
  fill(0);
  textSize(30);
  text("Usuario1",910,710); // AQUI VA EL NOMBRE DEL USUARIO
  popMatrix();

}

void displayTitle(){
  textSize(50);
  text("Titulo del juego",250,100);
}

void displayLogin(){
  background(0);
  fill(255);
  textSize(25);
  text("Escribe el nombre de usuario",400,300);
  text(userName, 400,340);
  //Crear o cargar usuario
  //Iterar sobre gameScore para cargar puntuaciones mas altas
}


void displayEditUser() {
  text("Cambiar imagen",250,340);
}

void changeUser(){
  //Guardar usuario
  userName = "";
  userLogged = false;
  resetMenu();
}

void displayOptions(){

}

void displayCredits(){

}




/*

------------------------------------- DISPLAYS ESPECIFICOS -------------------------------------

*/

void displayMainMenu(){
  textSize(30);
  fill(0);
  text("Minijuegos",250,300);
  text("Editar usuario",250,340);
  text("Cambiar usuario",250,380);
  text("Opciones",250,420);
  text("Creditos",250,460);
  text("Salir",250,500);
  displayMainBox();
}
void displayMainBox(){
  noFill();
  strokeWeight(5);
  rect(240,265+menuIndex*40,300,45);
}



void displayMinigames(){
  textSize(30);
  fill(0);
  text("P.A.", 440, 260);
  for(int i = 0; i < numberOfGames; i++){
    text(gameList[i].getGameName(),250,300+40*i);
    text(abs(gameScore[i]),440,300+40*i);
  }
  text("P.A. = puntuacion maxima actual para cada minijuego", 15, 700);
  
  
  displayMinigameBox();
}
void displayMinigameBox(){
  noFill();
  strokeWeight(5);
  rect(240,265+menuMinigamesIndex*40,300,45);
}




/*

------------------------------------- CONTROLES -------------------------------------

*/


void currentIndexUp(){
  switch(menuSelected){
    case -1:
    menuIndex--;
    if (menuIndex == -1){menuIndex = 5;} 
    break;
    case 0:
    menuMinigamesIndex--;
    if (menuMinigamesIndex == -1){menuMinigamesIndex = 2;}
    break;
  }

}

void currentIndexDown(){
  switch(menuSelected){
    case -1:
    menuIndex++;
    
    if (menuIndex == 6){menuIndex = 0;} 
    break;
    case 0:
    menuMinigamesIndex++;
    if (menuMinigamesIndex == 3){menuMinigamesIndex = 0;}
    break;
  }
}

void enterNewMenu(){
  switch(menuSelected){
    case -1:
      menuSelected = menuIndex;
    break;
    case 0:
      inGame = true;
    break;
    case 1:
      if(menuUserIndex == 0){
        //Borrar usuario
      } else {
        //Capturar imagen
      }
  }
  
}

void resetMenu(){
  menuIndex = 0;  menuMinigamesIndex = 0; menuOptionsIndex= 0; menuSelected = -1; menuUserIndex = 0;
  gameList[menuMinigamesIndex].reset();
  inGame = false;
}

void keyPressed(){
  if(userLogged){
    if(!gameList[menuMinigamesIndex].isInCountdown()){
      if (inGame){ 
        gameList[menuMinigamesIndex].control(key);
      } else {
        if(keyCode == UP){
          currentIndexUp();
        }
        
        if(keyCode == DOWN){
          currentIndexDown();
        }
        
        if(keyCode == ENTER){
          enterNewMenu();
        }
      }
      
      if(keyCode == BACKSPACE){
        checkGame();
        resetMenu();
      }
    }
  } else {
    if(keyCode == ENTER){
        //Llamadas a crear o comprobar usuario 
        userLogged = true;
      }
    if(key == BACKSPACE && userName.length() > 0){
          userName = userName.substring(0, userName.length()-1);
    } else {
      userName += key;
    }
  }
  
}
void mousePressed(){
  if(inGame){
    gameList[menuMinigamesIndex].control(mouseX, mouseY, (mouseButton ==  LEFT));
  }
}


/*

------------------------------------- CONTROLES AUXILIARES -------------------------------------

*/

void checkGame(){
  if(inGame &&  gameList[menuMinigamesIndex].isGameFinished()){
    println(gameList[menuMinigamesIndex].getScore());
    if(gameScore[menuMinigamesIndex] < gameList[menuMinigamesIndex].getScore()){
      gameScore[menuMinigamesIndex] = gameList[menuMinigamesIndex].getScore();
    }
  }
}
