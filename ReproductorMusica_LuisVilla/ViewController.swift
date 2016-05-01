//
//  ViewController.swift
//  ReproductorMusica_LuisVilla
//
//  Created by Luis Alejandro Villa Vargas on 30/04/16.
//  Copyright © 2016 Luis Alejandro Villa Vargas. All rights reserved.
//

import UIKit
import AVFoundation
import ImageIO
import MediaPlayer



class ViewController: UIViewController, AVAudioPlayerDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var songList: UIPickerView!
    @IBOutlet weak var songTitle: UILabel!
    @IBOutlet weak var volumeMainView: UIView!
    @IBOutlet weak var volumeSlider: UISlider!
    
    let songs = Cancion()
    
    
    private var player : AVAudioPlayer!
    private var playImage : UIImage!
    private var pauseImage : UIImage!
    private var sliderImage : UIImage!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        songList.dataSource = self
        songList.delegate = self
        
        coverImage.layer.borderColor = UIColor.whiteColor().CGColor
        coverImage.layer.borderWidth = 0.3
        
        playImage = UIImage(data: NSData(contentsOfURL: NSBundle.mainBundle().URLForResource("play", withExtension: "png")!)!)
        pauseImage = UIImage(data: NSData(contentsOfURL: NSBundle.mainBundle().URLForResource("pause", withExtension: "png")!)!)
        
      
            volumeSlider.enabled = true
            volumeSlider.hidden = false
       
    }
    
    override func viewWillAppear(animated: Bool) {
        
        playSelectedSong(0)
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return songs.data.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return (songs.data[row]["titulo"]! as! String)
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        playSelectedSong(row)
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        
        let pickerLabel = UILabel()
        
        pickerLabel.textColor = UIColor.blueColor()
        pickerLabel.text = (songs.data[row]["titulo"]! as! String)
        pickerLabel.font = UIFont(name: "Verdana", size: 13)
        pickerLabel.textAlignment = NSTextAlignment.Center
        
        return pickerLabel
    }
    
    func playSelectedSong (index: Int) {
        
        songTitle.text = (songs.data[index]["descripcion"]! as! String)
        coverImage.image =  songs.data[index]["imagen"] as? UIImage!
        
        if let titulo = songs.data[index]["titulo"] as? String {
            print(titulo)
            let sonidoURL = NSBundle.mainBundle().URLForResource(titulo, withExtension: "mp3")
            do {
                try player = AVAudioPlayer(contentsOfURL: sonidoURL!)
                
                player.delegate = self
                
                stop()
                play()
              
            } catch{
                print("error")
            }
        }

    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        
        if flag {
            
            playButton.setImage(playImage!, forState: UIControlState.Normal)
        }
    }
    
    @IBAction func play () {
        
        if player.playing {
            
            playButton.setImage(playImage!, forState: UIControlState.Normal)
            player.pause()
            
        } else {
            
            playButton.setImage(pauseImage!, forState: UIControlState.Normal)
            player.play()
        }
    }
    
    @IBAction func stop () {
        
        if player.playing {
            
            playButton.setImage(playImage!, forState: UIControlState.Normal)
            player.stop()
        }
        
        player.currentTime = 0.0
    }
    
    @IBAction func shuffle () {
        
        let index = Int(arc4random_uniform(UInt32(songs.data.count)))
        
        songList.selectRow(index, inComponent: 0, animated: true)
        playSelectedSong(index)
    }
    
    @IBAction func volumeValueChanged(sender: UISlider) {
        
        player.volume = sender.value
    }
    
  
}
