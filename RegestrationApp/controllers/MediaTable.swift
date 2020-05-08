//
//  ViewController.swift
//  Media_Table
//
//  Created by ahmedelbasha on 4/24/20.
//  Copyright © 2020 ahmedelbasha. All rights reserved.
//
import UIKit
import Alamofire
import AVKit
import SQLite

class MediaTable: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var selectedScope: UISegmentedControl!
    @IBOutlet weak var searchMedia: UISearchBar!
    var itunesArr: [Media] = []
    var searchedText: String!
    let playerViewController = AVPlayerViewController()
    let database = DatabaseManager.shared()
    var indicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Media List"
        database.searchedDataDbConnection()
        
        activityIndicator()
        self.tableView.reloadData()
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
       setupSearchBarView()
         selectedScope.addTarget(self, action: #selector(indexChanged), for: .valueChanged)
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
        self.showDetailViewController(playerViewController, sender: self)
        if database.isSearchedDataTableExists(){
            searchedText = database.getSearchedData()
            indexChanged()
        }
    }
    @objc func indexChanged() {
        if selectedScope.selectedSegmentIndex == 0 {
            
            getData(search:searchedText, scope: MediaType.all.rawValue )
        } else if selectedScope.selectedSegmentIndex == 1 {
          
             getData(search:searchedText, scope: MediaType.music.rawValue )
        } else if selectedScope.selectedSegmentIndex == 2 {
         
             getData(search:searchedText, scope: MediaType.movie.rawValue )
        }else if selectedScope.selectedSegmentIndex == 3 {
           
             getData(search:searchedText, scope: MediaType.tvShow.rawValue )
        }
        
    }
    private func setupSearchBarView(){
        searchMedia.delegate = self
        searchMedia.isTranslucent = false
        searchMedia.backgroundImage = UIImage()
        searchMedia.barTintColor = UIColor.purple
        searchMedia.tintColor = UIColor.white
    }
    
    private func getData(search: String, scope: String) {
        indicator.startAnimating()
        APIManger.loadMedia(search: search, scope: scope) { (error, mediaArr, mediaResult) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                if mediaResult == 0 {
                    if scope == "\(MediaType.all.rawValue )"{
                        self.itunesArr.removeAll()
                        self.tableView.reloadData()
                        self.indicator.stopAnimating()
                        self.showAlert(title: "this word doesn't have any result", massage: "search for another word")
                    }
                    self.itunesArr.removeAll()
                    self.tableView.reloadData()
                    self.indicator.stopAnimating()
                    self.showAlert(title:"there's no data to display for this search ", massage: "this search doesn't have any data in this scope which is \(scope) ")
                } else {
                    if let media = mediaArr {
                        self.itunesArr = media
                        self.indicator.stopAnimating()
                        self.tableView.reloadData()
                        self.tableView.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .top, animated: true)
                    }
                    
                }
            }
        }
    }
}

extension MediaTable: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itunesArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as? TableViewCell else {
            return UITableViewCell()
        }
        cell.shadowAndBorderForCell(yourTableViewCell: cell)
        cell.configurecell(media: itunesArr[indexPath.row])
        cell.indicator.startAnimating()
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        if itunesArr.count > 0 {
            self.tableView.backgroundView = nil
            self.tableView.separatorStyle = .singleLine
            return 1
        }
        
        let imageName = "pic nodata"
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image)
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        self.tableView.backgroundView = imageView
        self.tableView.separatorStyle = .none
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let mediaUrl = URL(string: itunesArr[indexPath.row].previewUrl ?? "") else {return}
        let player = AVPlayer(url: mediaUrl)
        self.playerViewController.player = player
        self.present(playerViewController, animated: true, completion: {
            self.playerViewController.player!.play()
        })
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return UITableView.automaticDimension
        } else {
            return 40
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return UITableView.automaticDimension
        } else {
            return 40
        }
    }
    
    
    func activityIndicator() {
        indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 500, height: 500))
      
        indicator.color = .darkGray
        indicator.center = self.view.center
        self.view.addSubview(indicator)
    }
}

extension MediaTable: UISearchBarDelegate {
    
  
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchMedia.text else { return }
       searchedText = text
        if searchedText == ""{
            showAlert(title: "there's no text", massage: "please put your text to search")
        }
        database.createSearchedDataTable(searchedText: text)
        indexChanged()
    }
    
}

