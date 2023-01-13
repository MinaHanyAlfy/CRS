//
//  CommentTableViewCell.swift
//  CRS
//
//  Created by John Doe on 2022-12-22.
//

import UIKit

protocol CommentTableViewDelegate: AnyObject {
    func getComment(comment: String)
}
class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var commentTextView: UITextView!
    public weak var delegate: CommentTableViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textViewHandle()
        
    }

    private func textViewHandle() {
        commentTextView.layer.borderWidth = 0.5
        commentTextView.layer.borderColor = UIColor(named: "bluePrimary")?.cgColor
        commentTextView.layer.cornerRadius = 8
        commentTextView.delegate = self
        if commentTextView.text.isEmpty {
            commentTextView.text = "Write your comment."
            commentTextView.textColor = UIColor(named: "bluePrimary")
        }
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension CommentTableViewCell: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        commentTextView.text = ""
        commentTextView.textColor = UIColor(named: "bluePrimary")
    }

    func textViewDidEndEditing(_ textView: UITextView) {
         if commentTextView.text.isEmpty {
             commentTextView.text = "Write your comment."
             commentTextView.textColor = UIColor(named: "bluePrimary")
         } else {
             let comment: String = commentTextView.text
             delegate?.getComment(comment: comment)
         }
           
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            if text == "\n"  // Recognizes enter key in keyboard
            {
                textView.resignFirstResponder()
                return false
            }
            return true
        }
}
