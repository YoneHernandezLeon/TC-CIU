import processing.video.*;
import processing.sound.*;

//Lista de variables que controlan cada menu
int menuIndex = 0, menuMinigamesIndex = 0, menuOptionsIndex= 0, menuEditUserIndex = 0, menuDeleteUserIndex = 0;
int maxMenu = 6, maxMinigames = 3, maxOptions = 3, maxEditUser = 2, maxDeleteUser = 2;
int menuSelected = -1; int filter = 0; int maxFilter = 5;

//Booleanos que controlan partes de los distintos menus
boolean userLogged = false;
boolean inGame = false;
boolean deleteUserMenu = false;
boolean changeImage = false;
boolean saveImage = false;


//Variables que controlan los minijuegos
int numberOfGames = 3;
MiniGame[] gameList = new MiniGame[numberOfGames];
String[] gameListScoreText = new String[numberOfGames];
int[] gameScore = new int[numberOfGames];

//Variables que controlan las variables de paletas
int maxPalette = 5;
Palette[] palettes = new Palette[maxPalette];
String[] palettesText = new String[maxPalette];

//Variables que controlan las variables de usuario
JSONArray appData;
String dataPath;
ManageUser mg;
User currentUser;
String userName = "";
int counter;
boolean on = true;

//Variables de control de audio y formatos
int barLimit = 300;
int volume = 50, sound = 50, palette = 0;
boolean volumeOption = false, soundOption = false, paletteOption = false, fontOption = false;

//Parametros multimedia
Capture cam;
boolean notCamera = false;
SoundFile S321, Ya, acierto, error, level_complete, menu, minigame, select;

void setup() {
  size(1280, 720, P2D);
  stroke(15);
  
  //Inicialización de audio
  S321 = new SoundFile(this, "Media/3_2_1.mp3");
  Ya = new SoundFile(this, "Media/Ya.mp3");
  acierto = new SoundFile(this, "Media/acierto.mp3");
  error = new SoundFile(this, "Media/error.mp3");
  level_complete = new SoundFile(this, "Media/level_complete.mp3");
  menu = new SoundFile(this, "Media/menu.mp3");
  minigame = new SoundFile(this, "Media/minigame.mp3");
  select = new SoundFile(this, "Media/select.mp3");

  //Inicialización de gestión de usuarios
  dataPath = "data/users.json";
  appData = loadJSONArray(dataPath);
  mg = new ManageUser(appData, dataPath);

  //Inicialización de paletas de colores
  palettes[0] = new Palette("img/palette/classic.png", 0, 0, 0);
  palettesText[0] = "Clásico";
  palettes[1] = new Palette("img/palette/warm.png", 75, 0, 0);
  palettesText[1] = "Cálido";
  palettes[2] = new Palette("img/palette/woods.png", 69, 35, 0);
  palettesText[2] = "Bosque";
  palettes[3] = new Palette("img/palette/cool.png", 0, 0, 75);
  palettesText[3] = "Frío";
  palettes[4] = new Palette("img/palette/negative.png", 255, 255, 255);
  palettesText[4] = "Negativo";
  
  //Inicialización de minijuegos
  gameList[0] = new Sudoku("Sudoku", palettes[0], S321, Ya, acierto, error, level_complete, minigame);
  gameListScoreText[0] = "Segundos";
  gameList[1] = new Memory("Memory", new Pulse(this), S321, Ya, level_complete);
  gameListScoreText[1] = "Racha de";
  gameList[2] = new CoinChange("Coins", maxPalette, S321, Ya, acierto, error, level_complete, minigame);
  gameListScoreText[2] = "Segundos";

  //Inicialización de camara
  String[] cameras = Capture.list();
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  }
  if (cameras.length >=1){
    cam = new Capture(this, 650, 480, cameras[0]);
    cam.start();
  } else {notCamera = true;}
}

void draw() {
  
  //Manejo de fondo y paletasa
  background(palettes[palette].img);
  fill(palettes[palette].r, palettes[palette].g, palettes[palette].b);
  textAlign(LEFT);
  
  //Gestor de menus
  if (userLogged) {
    displayRightPanel();
    if (!inGame) {
      if(!menu.isPlaying()){menu.loop();}
      displayTitle();
      switch(menuSelected) {
      case -1:
        displayMainMenu();
        break;
      case 0:
        displayMinigames();
        break;
      case 1:
        if (deleteUserMenu) {
          displayDeleteUser();
        } else if (changeImage) {
          displayChangeImage();
        } else {
          displayEditUser();
        }
        break;
      case 2:
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
      if(menu.isPlaying()){menu.stop();}
      gameList[menuMinigamesIndex].display(palettes[palette], palette, volume, sound);
    }
  } else {
    if(menu.isPlaying()){menu.stop();}
    displayLogin();
  }
}

void resetMenu() {
  gameList[menuMinigamesIndex].reset();
  menuIndex = 0;  
  menuMinigamesIndex = 0; 
  menuOptionsIndex= 0; 
  menuSelected = -1; 
  menuEditUserIndex = 0;
  paletteOption = false;
  inGame = false;
  deleteUserMenu = false;
  changeImage = false;
  saveImage = false;
}



// METODOS DE DISPLAY

//Muestra el panel derecho
void displayRightPanel() {
  line(900, 0, 900, 720);
  displayControlBox();
  displayUser();
}

//Muestra la caja de controles del panel derecho
void displayControlBox() {
  pushMatrix();
  noFill();
  rect(910, 20, 350, 290);
  if (!inGame) {
    fill(palettes[palette].r, palettes[palette].g, palettes[palette].b);
    textSize(20);
    if (!changeImage) {
      text("Usa las flechas arriba y abajo para\nmoverte por los distintos menus.\nPulsa las flechas izquierda y\nderecha para aumentar o disminuir\nlas opciones que lo requieran\nPulsa ENTER para acceder al\nmenu o juego\nPulsa RETROCESO para volver al\nmenu", 915, 45);
    } else {
      text("Usa las flechas izquierda y derecha\npara cambiar de filtro.\nPulsa ENTER para sacar una imagen\nPulsa RETROCESO para volver al\nmenu", 915, 45);
    }
  }
  popMatrix();
}

//Muestra el nombre y la imagen del usuario en el panel derecho
void displayUser() {
  pushMatrix();
  PImage img = loadImage(currentUser.getProfileImage());
  img.resize(350, 350);
  image(img, 910, 320);
  noFill();
  rect(910, 318, 350, 350);
  textSize(30);
  text(currentUser.getName(), 910, 703);
  popMatrix();
}

//Muestra el titulo del juego
void displayTitle() {
  textSize(50);
  textAlign(CENTER);
  text("Not Brain Nor Training", 450, 100);
  textAlign(LEFT);
}

//Muestra el Login
void displayLogin() {
  background(0);
  fill(255);
  textSize(25);
  text("Escribe el nombre de usuario", 390, 300);
  if(on){
    if(millis() > counter+500){
      on = false;
      counter = millis();
    }
    if(userName.length() < 26){text(userName+"_", 400, 340);} else{text(userName, 400, 340);}
  } else {
    if(millis() > counter+500){
      on = true;
      counter = millis();
    }
    text(userName, 400, 340);
  }
  noFill();
  stroke(255);
  rect(390,310,350,45);
  
}

//Muestra el menu de edicion de usuario
void displayEditUser() {
  textSize(30);
  text("Cambiar imagen", 250, 300);
  text("Eliminar usuario", 250, 340);
  displayEditUserBox();
}
void displayEditUserBox() {
  noFill();
  strokeWeight(5);
  stroke(15);
  rect(240, 265+menuEditUserIndex*40, 300, 45);
}

//Muestra el menu principal
void displayMainMenu() {
  textSize(30);
  fill(palettes[palette].r, palettes[palette].g, palettes[palette].b);
  text("Minijuegos", 250, 300);
  text("Editar usuario", 250, 340);
  text("Cambiar usuario", 250, 380);
  text("Opciones", 250, 420);
  text("Creditos", 250, 460);
  text("Salir", 250, 500);
  displayMainBox();
}
void displayMainBox() {
  noFill();
  strokeWeight(5);
  stroke(15);
  rect(240, 265+menuIndex*40, 300, 45);
}

//Muestra el menu de minijuegos
void displayMinigames() {
  textSize(30);
  fill(palettes[palette].r, palettes[palette].g, palettes[palette].b);
  text("Puntuación", 440, 260);
  for (int i = 0; i < numberOfGames; i++) {
    String gameName = gameList[i].getGameName();
    int gameScore = currentUser.getScoreOf(gameName);
    text(gameName, 250, 300+40*i);
    if ( gameScore == -1) {
      text(" -", 440, 300+40*i);
    } else {
      if (i == 1) {
        text(gameListScoreText[i]+" "+abs(gameScore), 440, 300+40*i);
      } else {
        text(abs(gameScore)+" "+gameListScoreText[i], 440, 300+40*i);
      }
    }
  }
  displayMinigameBox();
}
void displayMinigameBox() {
  noFill();
  strokeWeight(5);
  stroke(15);
  rect(240, 265+menuMinigamesIndex*40, 150, 45);
}

//Muestra el menu de opciones
void displayOptions() {
  textSize(40);
  text("Opciones", 320, 250);
  textSize(30);
  text("Volumen de musica", 250, 300);
  textSize(20);
  text("<-", 250, 337);
  text("->", 250+50+barLimit, 337);
  noFill();
  rect(290, 320, barLimit, 20);
  fill(palettes[palette].r, palettes[palette].g, palettes[palette].b);
  rect(290, 320, volume*3, 20);
  fill(palettes[palette].r, palettes[palette].g, palettes[palette].b);  
  textSize(30);

  text("Volumen de sonido", 250, 390);
  textSize(20);
  text("<-", 250, 427);
  text("->", 250+50+barLimit, 427);
  noFill();
  rect(290, 410, barLimit, 20);
  fill(palettes[palette].r, palettes[palette].g, palettes[palette].b);
  rect(290, 410, sound*3, 20);
  fill(palettes[palette].r, palettes[palette].g, palettes[palette].b);
  textSize(30);
  text("Cambiar paleta de colores", 250, 480);
  textSize(20);
  text("<-  "+palettesText[palette]+ "  ->", 250, 520);
  displayOptionsBox();
}
void displayOptionsBox() {
  noFill();
  stroke(15);
  strokeWeight(5);
  if (menuOptionsIndex == 0) {
    rect(240, 265, 400, 45);
    volumeOption = true;
    soundOption = false;
    paletteOption = false;
  } else if (menuOptionsIndex == 1) {
    rect(240, 315+menuOptionsIndex*40, 400, 45);
    volumeOption = false;
    soundOption = true;
    paletteOption = false;
  } else if (menuOptionsIndex == 2) {
    rect(240, 365+menuOptionsIndex*40, 400, 45);
    volumeOption = false;
    soundOption = false;
    paletteOption = true;
  } else {
    rect(240, 355+menuOptionsIndex*40, 390, 45);
    volumeOption = false;
    soundOption = false;
    paletteOption = false;
  }
}

//Muestra los creditos
void displayCredits() {
  textSize(40);
  textAlign(CENTER);
  text("Aplicación desarrollada por:", 450, 250);
  strokeWeight(5);
  textSize(30);
  textAlign(CENTER);
  text("Yone Hernández León\nCarlos Javier Martín Perdomo\nFrancisco Jose Santana Sosa\n\nCon la colaboración musical de:\nNicolás Almeida Ramírez", 450, 300);
  textAlign(LEFT);
}

//Muestra el menu de confirmación de eliminar usuario
void displayDeleteUser() {
  textSize(40);
  text("¿Estas seguro?", 320, 250);
  textSize(30);
  text("Sí", 250, 300);  
  textSize(30);
  text("No", 250, 340); 
  displayDeleteUserBox();
}
void displayDeleteUserBox() {
  noFill();
  strokeWeight(5);
  stroke(15);
  rect(240, 265+menuDeleteUserIndex*40, 300, 45);
}

//Muestra el menu de cambiar imagen
void displayChangeImage() {
  if (cam.available()) {
    cam.read();
  }
  if (!notCamera){
    int w = cam.width;
    int h = cam.height;
    image(cam, 450-w/2, 400-h/2);
    PImage img = get(225, 175, 450, 450);
    image(img, 225, 175);
    
    switch(filter){
      case 0:
        textAlign(CENTER);
        text("Normal",450,700);
        textAlign(LEFT);
        break;
      case 1:
        textAlign(CENTER);
        text("Umbral",450,700);
        textAlign(LEFT);
        img.filter(THRESHOLD);
        break;
      case 2:
        textAlign(CENTER);
        text("Escala de grises",450,700);
        textAlign(LEFT);
        img.filter(GRAY);
        break;
      case 3:
        textAlign(CENTER);
        text("Invertido",450,700);
        textAlign(LEFT);
        img.filter(INVERT);
        break;
      case 4:
        textAlign(CENTER);
        text("Polarizado",450,700);
        textAlign(LEFT);
        img.filter(POSTERIZE, 3);
        break;
    }
    
    stroke(15);
    rect(450-w/2, 400-h/2, 650, 480);
    stroke(255);
    rect(225, 175, 450, 450);
    stroke(15);
    fill(palettes[palette].r, palettes[palette].g, palettes[palette].b);
    if(saveImage){
      img.save("img/users/" + currentUser.getName() + "_img.png");
      currentUser.setProfileImage("img/users/" + currentUser.getName() + "_img.png");
      mg.saveUser(currentUser);
      resetMenu();
    }
  } else {
    text("Necesitas una camara para cambiar de imagen.\nPulsa retroceso para volver al menu",15,300);
  }
}
/*

 ------------------------------------- CONTROLES -------------------------------------
 
 */


//Mueve el menu a la opcion de arriba
void currentIndexUp() {
  switch(menuSelected) {
  case -1:
    menuIndex--;
    if (menuIndex == -1) {
      menuIndex = maxMenu-1;
    } 
    break;
  case 0:
    menuMinigamesIndex--;
    if (menuMinigamesIndex == -1) {
      menuMinigamesIndex = maxMinigames-1;
    }
    break;
  case 1:
    if (deleteUserMenu) {
      menuDeleteUserIndex--;
      if (menuDeleteUserIndex == -1) {
        menuDeleteUserIndex = maxDeleteUser-1;
      }
    } else {
      menuEditUserIndex--;
      if (menuEditUserIndex == -1) {
        menuEditUserIndex = maxEditUser-1;
      }
    }
  case 3:
    menuOptionsIndex--;
    if (menuOptionsIndex == -1) {
      menuOptionsIndex = maxOptions-1;
    }
    break;
  }
}

//Mueve el menu a la opcion de abajo
void currentIndexDown() {
  switch(menuSelected) {
  case -1:
    menuIndex++;

    if (menuIndex == maxMenu) {
      menuIndex = 0;
    } 
    break;
  case 0:
    menuMinigamesIndex++;
    if (menuMinigamesIndex == maxMinigames) {
      menuMinigamesIndex = 0;
    }
    break;
  case 1:
    if (deleteUserMenu) {
      menuDeleteUserIndex++;
      if (menuDeleteUserIndex == maxDeleteUser) {
        menuDeleteUserIndex = 0;
      }
    } else {
      menuEditUserIndex++;
      if (menuEditUserIndex == maxEditUser) {
        menuEditUserIndex = 0;
      }
    }
  case 3:
    menuOptionsIndex++;
    if (menuOptionsIndex == maxOptions) {
      menuOptionsIndex = 0;
    }
    break;
  }
}

//Entra en el menu seleccionado
void enterNewMenu() {
  switch(menuSelected) {
  case -1:
    menuSelected = menuIndex;
    break;
  case 0:
    inGame = true;
    break;
  case 1:
    if (menuEditUserIndex == 0) {
      if (changeImage){
        saveImage = true;
      } else {
        changeImage = true;
      }
    } else {
      if (menuDeleteUserIndex == 0 && deleteUserMenu) {
        mg.removeUser(currentUser);
        currentUser = null;
        userLogged = false;
        userName = "";
        resetMenu();
      } else if (menuDeleteUserIndex == 1 && deleteUserMenu) {
        resetMenu();
      } else {
        deleteUserMenu = true;
      }
    }
  }
}

void keyPressed() {
  if (userLogged) {
    if (!gameList[menuMinigamesIndex].isInCountdown()) {
      if (inGame) { 
        gameList[menuMinigamesIndex].control(key);
      } else {
        if (keyCode == UP) {
          currentIndexUp();
          select.play();
        }

        if (keyCode == DOWN) {
          currentIndexDown();
          select.play();
        }

        if (keyCode == ENTER) {
          enterNewMenu();
        }

        if (keyCode == LEFT && volumeOption) {
          volume-=10;
          if (volume<0) {
            volume=0;
          }
          setVolume();
        }
        if (keyCode == RIGHT && volumeOption) {
          volume+=10;
          if (volume>100) {
            volume=100;
          }
          setVolume();
        }

        if (keyCode == LEFT && soundOption) {
          sound-=10;
          if (sound<0) {
            sound=0;
          }
          setSound();
        }
        if (keyCode == RIGHT && soundOption) {
          sound+=10;
          if (sound>100) {
            sound=100;
          }
          setSound();
        }

        if (keyCode == LEFT && paletteOption) {
          palette--;
          if (palette<0) {
            palette=maxPalette - 1;
          }
        }
        if (keyCode == RIGHT && paletteOption) {
          palette++;
          if (palette==maxPalette) {
            palette = 0;
          }
        }
        
        if (keyCode == LEFT && changeImage) {
          filter--;
          if (filter<0) {
            filter=maxFilter - 1;
          }
        }
        if (keyCode == RIGHT && changeImage) {
          filter++;
          if (filter==maxFilter) {
            filter = 0;
          }
        }
      }

      if (keyCode == BACKSPACE) {
        checkGame();
        resetMenu();
      }
    }
  } else {
    if (keyCode == ENTER && userName.length() > 0) {
      currentUser = mg.login(userName);
      volume = currentUser.getPreference("Volume");
      sound = currentUser.getPreference("Sound");
      palette = currentUser.getPreference("Palette");
      userLogged = true;
    }

    if (keyCode == BACKSPACE && userName.length() > 0) {
      userName = userName.substring(0, userName.length() - 1);
    } else if (keyCode >= 32 && keyCode <= 94  && userName.length() < 26) {
      userName += key;
    }
  }
}
void mousePressed() {
  if (inGame) {
    gameList[menuMinigamesIndex].control(mouseX, mouseY, (mouseButton ==  LEFT));
  }
}


/*

 ------------------------------------- CONTROLES Y METODOS AUXILIARES -------------------------------------
 
*/

//Realiza el cambio de usuario
void changeUser() {
  userName = "";
  userLogged = false;
  currentUser.setPreference(volume, "Volume");
  currentUser.setPreference(sound, "Sound");
  currentUser.setPreference(palette, "Palette");
  mg.saveUser(currentUser);
  resetMenu();
}
 
//Pone los sonidos a su volumen correcto
void setSound(){
  S321.amp(float(sound)/100.0);
  Ya.amp(float(sound)/100.0);
  acierto.amp(float(sound)/100.0);
  error.amp(float(sound)/100.0);
  select.amp(float(sound)/100.0);
}

//Pone la musica a su volumen correcto
void setVolume(){
  level_complete.amp(float(volume)/100.0);
  menu.amp(float(volume)/100.0);
  minigame.amp(float(volume)/100.0);
}


//Comprueba si la partida ha terminado
void checkGame() {
  if (inGame &&  gameList[menuMinigamesIndex].isGameFinished()) {
    currentUser.setScoreOf(gameList[menuMinigamesIndex].getScore(), gameList[menuMinigamesIndex].getGameName());
  }
}

void exit() {
  if (currentUser != null) {
    currentUser.setPreference(volume, "Volume");
    currentUser.setPreference(sound, "Sound");
    currentUser.setPreference(palette, "Palette");
    mg.saveUser(currentUser);
  }
  super.exit();
}

class Palette {

  public PImage img;
  public int r, g, b;

  Palette(String i, int r, int g, int b) {
    this.img = loadImage(i);
    this.r = r;
    this.g = g;
    this.b = b;
  }
}
