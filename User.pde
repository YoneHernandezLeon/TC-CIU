class User{ 
  private final int ID;
  private String name;
  //valores por defecto en la puntuación del usuario(indica que el usuario no hajugado) cuando se crea
  private int[] score = {-1, -1, -1}; 
  //valores por defecto en las opciones de sonido y color de paleta
  private int[] preferences = {50, 50, 0};
  private String profileImage;
  
  public User(int ID, String name){
    this.ID = ID;
    this.name = name;
    //cuando se crea un usuario se le da una foto de perfil por defecto
    this.profileImage = "img/users/default.jpeg";
  }
  
  public void setName(String name){
    this.name = name;
  }
  
  public void setProfileImage(String profileImage){
    this.profileImage = profileImage;
  }
  
  //Añade una puntación si no se ha jugado a un minijuego, o en caso de obtener una mejor
  public void setScoreOf(int newScore, String game){
    switch(game){
      case "Sudoku":
        if(newScore < score[0] || score[0] == -1) score[0] = newScore;
        break;
      case "Coins":
        if(newScore < score[1] || score[1] == -1) score[1] = newScore;
        break;
      case "Memory":
        if(newScore > score[2] || score[2] == -1) score[2] = newScore;
        break;
      default:
        break;
    }
  }
  
  //Cambia el valor de una opción como volumen, sonido y color de paleta
  public void setPreference(int value, String preference){
    switch(preference){
      case "Volume":
        preferences[0] = value;
        break;
      case "Sound":
        preferences[1] = value;
        break;
      case "Palette":
        preferences[2] = value;
        break;
      default:
        break;
    }
  }
  
  public String getName(){
    return name;
  }
  
  public String getProfileImage(){
    return profileImage;
  }
  
  public int getScoreOf(String game){
    int index = 0;
    switch(game){
      case "Sudoku":
        index = 0;
        break;
      case "Coins":
        index = 1;
        break;
      case "Memory":
        index = 2;
        break;
      default:
        break;
    }
    return score[index];
  }
  
  public int getPreference(String preference){
    int index = 0;
    switch(preference){
      case "Volume":
        index = 0;
        break;
      case "Sound":
        index = 1;
        break;
      case "Palette":
        index = 2;
        break;
      default:
        break;
    }
    return preferences[index];  
  }
  
  public int getID(){
    return ID;
  }
}
