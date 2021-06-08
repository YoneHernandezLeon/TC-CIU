import processing.sound.*;

class Memory extends MiniGame{
  
  
  //Variables de gestion
  private boolean waiting, isGameLoose;
  private int nSounds;
  private ArrayList<myKey> keyList; 
  private boolean displaySound, userKeyPress;
  private int currentSounds, solvedSounds, pressedKey;
  private int[] levelList;
  private myKey currentKey;
  
  //Sonido de pulso
  private Pulse pulso;
  
  //Paleta de colores
  private Palette p;
  
  //Imagenes del how to play
  private PImage img0, img1;
  
  //Sonido
  private int sound;
  private SoundFile level_complete;
  
  Memory(String gameName, Pulse pulso, SoundFile S321, SoundFile Ya, SoundFile level_complete) {
    this.S321 = S321;
    this.Ya = Ya;
    this.level_complete = level_complete;

    this.gameName = gameName;
    this.pulso = pulso;
    
    waiting = false;
    nSounds = 1;
    currentSounds = 0;
    solvedSounds = 0;
    pressedKey = 0;
    displaySound = false;
    userKeyPress = false;
    isGameLoose = false;
    
    img0 = loadImage("img/howto/memoryImg0.jpeg");
    img0.resize(300, 240);
    img1 = loadImage("img/howto/memoryImg1.jpeg");
    img1.resize(300, 240);
    
    createKeyList();
  }
  
  void reset(){
    super.reset();
    waiting = false;
    nSounds = 1;
    currentSounds = 0;
    solvedSounds = 0;
    pressedKey = 0;
    displaySound = false;
    userKeyPress = false;
    isGameLoose = false;
  }
  
  void endGame(){
    fill(p.r, p.g, p.b);
    textSize(50);
    text("Has perdido con una racha de "+ score,15,300);
    text("Pulsa retroceso para volver al menu",15,700);
  }
  
  void controlDisplay(){
    pushMatrix();
    fill(p.r, p.g, p.b);
    textSize(20);
    text("Click izquierdo sobre una tecla\npara seleccionarla como la\nsiguiente tecla de secuencia\n\nPulsa RETROCESO para abandonar\nla partida y volver al menu", 915, 45);
    popMatrix();
  }
  
  void display(Palette p, int palette, int volume, int sound){
    this.sound = sound;
    this.p = p;
    if(!isGameLoose){
      if(start){
        if (timerFinished){
          inGame();
        } else {
          countDown();
        }
      } else {
        howToPlay();
      }
    } else {
      endGame();
      
    }
  }
  
  
  void howToPlay(){
    pushMatrix();
    fill(p.r, p.g, p.b);
    textSize(50);
    textAlign(CENTER, CENTER);
    text("MEMORY",450,60);
    textSize(30);
    textAlign(LEFT);
    text("Instrucciones",15,140);
    textSize(20);
    text(
    "-Este minijuego consiste en escuchar y ver una secuencia de sonidos y luces y repetirla\npulsando las mismas teclas.La puntuacion del juego esta definida por el \nnumero de secuencias seguidas que aciertes.\n"+
    "-Tanto el sonido como la iluminacion se mantendran durante 1 segundo. Tras completar\ncorrectamente una secuencia habra una pausa de 1 segundo antes de comenzar la\nsiguiente. Se indicara con simbolo de \"pause\" cuando el usuario se encuentre a la espera\nde la secuencia y un simbolo de \"play\" cuando el usuario tenga que clickar la secuencia"
    ,15,180);
    text("Pulsa enter para comenzar", 15, 700);
    text("Pulsa retroceso para volver al menu", 540, 700);
    
    image(img0, 100, 420);
    image(img1, 500, 420);
    
    popMatrix();
    controlDisplay();
  }
  
  void inGame(){
    displayKeyList();
    displayText();
    controlDisplay();
    
    
    if(displaySound){
      pulso.freq(currentKey.getFreq());
      pulso.amp((float)sound/1000.0);
      pulso.play();
      delay(1000);
      pulso.stop();
      
      currentKey.display(false);
      displaySound = false;
    }
    
    if(waiting){
      if(solvedSounds == nSounds){
        score++;
        currentSounds = 0;
        waiting = false;
        nSounds++;
        delay(1000);
      } else {
        if(userKeyPress){
          if(pressedKey == levelList[solvedSounds]){
            userKeyPress = false;
            solvedSounds++;
          } else {
            level_complete.play();
            isGameLoose = true;
          }
        }
      } 
    } else {
      if(currentSounds == nSounds){
        solvedSounds = 0;
        waiting = true;    
      } else {
        generateNext();
        //generando sonidos del nivel actual
      }
    }
  }
  
  //Muestra la informacion de la partida
  void displayText(){
    pushMatrix();
    textSize(30);
    fill(p.r, p.g, p.b);
    text("Racha = "+score,20,65);
    textSize(30);
    if(waiting){
      pushMatrix();
      triangle(500,75,500,25,550,50);
      popMatrix();
    } else {      
      rect(500,35,20,50,20,20,20,20);
      rect(540,35,20,50,20,20,20,20);      
    }
    popMatrix();
  }
  
  //Crea las teclas
  void createKeyList(){
    keyList = new ArrayList<myKey>();
    keyList.add(new myKey(0,100,450,410,1,0,255,0,150));
    keyList.add(new myKey(450,100,900,410,2,255,0,0,200));
    keyList.add(new myKey(0,410,450,720,3,255,255,0,250));
    keyList.add(new myKey(450,410,900,720,4,0,0,255,300));
  }

  //Muestra las teclas
  void displayKeyList(){
    for( myKey k : keyList){
      k.display(false);
    }
  }
  
  //Comprueba sobre que tecla se ha pulsado
  int checkKeys(int x, int y){
    for(myKey k : keyList){
      if(k.isInside(x,y)){
        return k.getCount();
      }
    }
    return -1;
  }
  
  //Genera la siguiente combinación de teclas
  void generateNext(){
    int r;
    if(currentSounds > 0){
       r = levelList[currentSounds-1];
       while (r == levelList[currentSounds-1]){
         r = (int) random(1,16);
       }
    } else {
      levelList = new int[nSounds];
      r = (int) random(1,16);
    }
    
    for( myKey k : keyList){
      if(k.getCount() == r){
        levelList[currentSounds] = r;
        currentSounds++;
        currentKey = k;
        showKey();
        break;
      }   
    }
  }
  
  //Eniende la tecla pulsada y activa la reproduccion de su sonido
  void showKey(){
    currentKey.display(true);
    displaySound = true;
  }
  
  //Comprueba la tecla pulsada
  void checkSound(int count){
    if(count != -1){
      userKeyPress = true;  
      pressedKey = count;
      for(myKey k : keyList){
        if(k.getCount() == count){
          currentKey = k;
          break;
        }
      }
      showKey();
    } 
  }
  
  String getGameName(){
    return gameName;
  }
  
  
  boolean isGameFinished(){
    return isGameLoose;
  }
  
  
  void control(int keyPress){
    if(keyPress == ENTER){
      millis = millis();
      start = true;
    }
  }
  
  
  void control(int x, int y, boolean left){
    if(!isGameLoose && timerFinished){
      checkSound(checkKeys(x, y));
    }
  }

}


class myKey{

  int x, y, finx, finy, count, R, G, B, freq;
  
  myKey(int x, int y, int finx, int finy, int count, int R, int G, int B, int freq){
    this.x = x;
    this.y = y;
    this.finx = finx;
    this.finy = finy;
    this.count = count;
    this.R = R;
    this.G = G;
    this.B = B;
    this.freq = freq;
  }

  boolean isInside(int x, int y){
    if(x > this.x && x < this.finx && y > this.y && y < this.finy){
      return true;
    }
    return false;
  }
  
  void display(boolean b){
    if(b){
      fill(R,G,B, 250);
    } else {
      fill(R,G,B, 80);
    }
    rect(x,y, finx - x,finy - y);

  }
  
  int getX(){
    return x;
  }
  
  int getY(){
    return y;
  }
  
  int getfinX(){
    return finx;
  }
  
  int getfinY(){
    return finy;
  }
  
  int getCount(){
    return count;
  }
  
  int getFreq(){
    return freq;
  }
  
}
