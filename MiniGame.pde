abstract class MiniGame {
  boolean start = false;
  
  boolean timerFinished = false, countdownOn = false;
  int millis;
  
  int score = 0;
  
  String gameName = "";
  
  
  
  /*
  Este metodo se encarga de gestionar que se muestre el juego o las instrucciones.
  
  Gestion basica usando el parametro start
    start = false && timer != 0 -> howToPlay()
    start = true -> inGame()
  
  */
  abstract void display(Palette p, int palette, int volume, int sound);
  
  
  /*
  Este metodo muestra las instrucciones
  */
  abstract void howToPlay();
  
  /*
  Este metodo se encarga de mostrar los controles
  */
  abstract void controlDisplay();
 
 
  /*
  Este metodo se encarga de resetear las variables del minijuego
  */
  void reset(){
    start = false;
    timerFinished = false;
    countdownOn = false;
    millis = 0;
    score = 0;
  }
  
  /*
  Este metodo se encarga de mostrar y terminar correctamente la partida
  */
  abstract void endGame();
  
  /*
  Este metodo muestra y gestiona todo el juego como tal
  */
  abstract void inGame();
  
  
  /**
  Este metodo retorna la puntuacion actual
  
  Devuelve:
    int score: Puntuacion del juego
  */
  int getScore(){
    return score;
  }
  
  
  
  /**
  Este metodo retorna el nombre del juego
  
  Devuelve:
    String gameName: Nombre del juego
  */
  String getGameName(){
    return gameName;
  }
  
  
  /*
  Este metodo se encarga de mostrar por pantalla una cuenta atras de 3 segundos antes de comenzar el juego
  */
  void countDown(){
    countdownOn = true;
    stroke(0);
    textSize(50);
    textAlign(CENTER,CENTER);
    if(millis - millis() <= -1000){
      if(millis - millis() <= -2000 ){
        if(millis - millis() <= -3000 ){
          text("YA",450,340);
          textAlign(LEFT);
          if(millis - millis() <= -3400 ){
            countdownOn = false;
            timerFinished = true;
          }
        } else{
          text("1",450,340);
        }
      } else {
        text("2",450,340);
      }
    } else {
      text("3",450,340);   
    }
  }
  
  /*
  Este metodo devuelve si el progrograma se encuentra dentro de la cuenta atras o no.
  Durante este tiempo el usuario no puede interactuar.
  
  Devuevle:
    boolean countdownOn: Esta variable esta a true mientras el contador este activado y a false cuando se termine
  */
  boolean isInCountdown(){
    return countdownOn;
  }
  
  /*
  Este metodo devuelve si la partida a acabado correctamente o si ha perdido
  Devuelve:
    true/false: Partida completada/Partida perdida 
  */
  abstract boolean isGameFinished();
  
  /*
  Este metodo se encarga de recibir la tecla pulsada para su gestion apropiada
  
  Gestion usando el parametro start:
    Cuando se pulse por primera vez ENTER se pondra start=true y se llama a countDown
  
  
  Parametros:
    int keyPress: La tecla pulsada
  */
  abstract void control(int keyPress);
  
  
  /*
  Este metodo se encarga de recibir las coordenadas del raton y un booleano indicando que tipo de click se recibe (izquierod o derecho)
  
  Parametros:
    int x: Posicion x del raton
    int y: Posicion y del raton
    boolean left: Sera true cuando se produzca un click izquierdo y false cuando se produzca un click derecho
  */
  abstract void control(int x, int y, boolean left);
}
