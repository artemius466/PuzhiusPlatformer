import java.awt.datatransfer.Clipboard;
import java.awt.datatransfer.Transferable;
import java.awt.datatransfer.DataFlavor;
import java.awt.datatransfer.UnsupportedFlavorException;

Textfield ipAddress;
Textfield mapName;
Button serverBtn;
Button clientBtn;
Button mapFileBtn;
Button pasteBtn;
Button settingsBtn;
Button SP;
Button backBtn;
Slider volumeSlider;


boolean fileLoading = false;

String GetTextFromClipboard () {
  String text = (String) GetFromClipboard(DataFlavor.stringFlavor);

  if (text==null)
    return "";

  return text;
}

Object GetFromClipboard (DataFlavor flavor) {

  Clipboard clipboard = getJFrame(getSurface()).getToolkit().getSystemClipboard();

  Transferable contents = clipboard.getContents(null);
  Object object = null; // the potential result

  if (contents != null && contents.isDataFlavorSupported(flavor)) {
    try
    {
      object = contents.getTransferData(flavor);
      println ("Clipboard.GetFromClipboard() >> Object transferred from clipboard.");
    }

    catch (UnsupportedFlavorException e1) // Unlikely but we must catch it
    {
      println("Clipboard.GetFromClipboard() >> Unsupported flavor: " + e1);
      e1.printStackTrace();
    }

    catch (java.io.IOException e2)
    {
      println("Clipboard.GetFromClipboard() >> Unavailable data: " + e2);
      e2.printStackTrace() ;
    }
  }

  return object;
}

static final javax.swing.JFrame getJFrame(final PSurface surf) {
  return
    (javax.swing.JFrame)
    ((processing.awt.PSurfaceAWT.SmoothCanvas)
    surf.getNative()).getFrame();
}

class Menu {
  Menu() {
  }

  public int screen = 0;
  public boolean titleEnd = false;


  void init(ControlP5 cp5) {
    delay(5000);

    PFont bigFont = createFont("data/Azonix.otf", 45);
    PFont minFont = createFont("data/Azonix.otf", 30);
    textFont(bigFont);
    textSize(75);
    textAlign(CENTER);
    text("Puzhius Platformer", width/2, 200);

    serverBtn = new Button(cp5, "Server");
    serverBtn.setValue(0);
    serverBtn.setPosition(width/2-400/2, 300);
    serverBtn.setSize(400, 100);
    serverBtn.setFont(bigFont);

    clientBtn = new Button(cp5, "Client");
    clientBtn.setValue(0);
    clientBtn.setPosition(width/2-400/2, 410);
    clientBtn.setSize(400, 100);
    clientBtn.setFont(bigFont);

    ipAddress = new Textfield(cp5, "IP Address");
    ipAddress.setPosition(width/2-400/2, 300);
    ipAddress.setSize(400, 50);
    ipAddress.setFont(minFont);
    ipAddress.setFocus(true);
    ipAddress.setColor(color(255, 255, 255));
    ipAddress.setText("");

    mapName = new Textfield(cp5, "Map file name");
    mapName.setPosition(width/2-400/2, 380);
    mapName.setSize(400, 50);
    mapName.setFont(minFont);
    mapName.setFocus(true);
    mapName.setColor(color(255, 255, 255));
    mapName.setText("");

    mapFileBtn = new Button(cp5, "Select");
    mapFileBtn.setValue(0);
    mapFileBtn.setPosition(width/2+450/2, 380);
    mapFileBtn.setSize(200, 50);
    mapFileBtn.setFont(minFont);
    mapFileBtn.activateBy(ControlP5.RELEASE);

    pasteBtn = new Button(cp5, "Paste");
    pasteBtn.setValue(0);
    pasteBtn.setPosition(width/2+450/2, 300);
    pasteBtn.setSize(200, 50);
    pasteBtn.setFont(minFont);
    
    SP = new Button(cp5, "SinglePlayer");
    SP.setValue(0);
    SP.setPosition(width/2-400/2, 520);
    SP.setSize(400, 100);
    SP.setFont(bigFont);

    settingsBtn = new Button(cp5, "Settings");
    settingsBtn.setValue(0);
    settingsBtn.setPosition(width/2-400/2, 630);
    settingsBtn.setSize(400, 100);
    settingsBtn.setFont(bigFont);
    
    volumeSlider = new Slider(cp5, "Volume"); 
    volumeSlider.setMax(1.0f);
    volumeSlider.setPosition(width/2-200/2, 470);
    volumeSlider.setSize(200, 30);
    volumeSlider.setValue(1.0f);
    

    backBtn = new Button(cp5, "Back");
    backBtn.setValue(0);
    backBtn.setPosition(width/2-200/2, 520);
    backBtn.setSize(200, 50);
    backBtn.setFont(bigFont);
  }



  void act() {
    if (!fileLoading) {
      background(black);
      PFont bigFont = createFont("data/Azonix.otf", 50);

      textFont(bigFont);
      textSize(75);
      textAlign(CENTER);

      if (settingsBtn.isPressed()) screen = 1;
      if (backBtn.isPressed()) screen = 0;



      if (screen == 0) {
        text("Puzhius Platformer", width/2, 200);
        pasteBtn.hide();
        mapFileBtn.hide();
        ipAddress.hide();
        mapName.hide();
        backBtn.hide();
        volumeSlider.hide();

        serverBtn.show();
        clientBtn.show();
        SP.show();
        settingsBtn.show();
      } else if (screen == 1) {
        text("Puzhius Settings", width/2, 200);
        serverBtn.hide();
        clientBtn.hide();
        settingsBtn.hide();
        SP.hide();

        backBtn.show();
        volumeSlider.show();
        pasteBtn.show();
        mapFileBtn.show();
        ipAddress.show();
        mapName.show();


        if (pasteBtn.isPressed()) ipAddress.setText(GetTextFromClipboard());
        //if (mapFileBtn.isPressed()) {
        //  selectInput("Select a file to process:", "fileSelected");
        //}
      }
    }
  }

  void destroy() {
    serverBtn.hide();
    clientBtn.hide();
    settingsBtn.hide();
    SP.hide();
  }

  boolean getServerBtn() {
    return serverBtn.isPressed();
  }
  boolean getClientBtn() {
    return clientBtn.isPressed();
  }
  
  boolean getSP() {
    return SP.isPressed();
  }

  String getIpAddress() {
    return ipAddress.getText();
  }

  void setIpAddress(String text) {
    ipAddress.setText(text);
  }

  String getMap() {
    return mapName.getText();
  }

  void setMap(String text) {
    mapName.setText(text);
  }
  
  
  void setVolume(float volume) {
    volumeSlider.setValue(volume);    
  }
  
  float getVolume() {
     return volumeSlider.getValue();
  }
}

void fileSelected(File selection) {
  if (selection != null) {
    mapName.setText(selection.getAbsolutePath());
    fileLoading = false;
  } else {
    fileLoading = false;
  }
}

boolean oldPress = false;

public void Select() {
  println("Puzhaa");
  if (oldPress == true) {
    selectInput("Select a file to process:", "fileSelected");
  } else {
    oldPress = true;
  }
}
