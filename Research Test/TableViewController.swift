//
//  TableViewController.swift
//  Research Test
//
//  Created by Isaias Rocha Lima on 22/02/16.
//  Copyright © 2016 Lima. All rights reserved.
//

import UIKit
import ResearchKit

class TableViewController: UITableViewController, ORKTaskViewControllerDelegate {
    
    let userData = [("Nome","Isaías Lima") , ("Peso","62kg") , ("Nascimento","11/09/1995") , ("e-mail","isaiahlima18@gmail.com")]
    @IBOutlet weak var headerView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        headerView.frame.size.height = 400
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0:
            return userData.count
        case 1:
            return 2
        default:
            return 1
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier("userData", forIndexPath: indexPath)
            let datum = userData[indexPath.row]
            cell.textLabel?.text = datum.0
            cell.detailTextLabel?.text = datum.1
            return cell
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier("button", forIndexPath: indexPath)
            if indexPath.row == 0 {
                cell.textLabel?.text = "Inventário breve de dor"
            } else {
                cell.textLabel?.text = "Marcar consulta"
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 && indexPath.row == 0 {
            let taskViewController = IRLTaskViewController(task: BriefPainInvetoryTask, taskRunUUID: nil)
            taskViewController.delegate = self
            taskViewController.outputDirectory = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0], isDirectory: true)
            presentViewController(taskViewController, animated: true, completion: nil)
        }
    }
    
    func taskViewController(taskViewController: ORKTaskViewController, didFinishWithReason reason: ORKTaskViewControllerFinishReason, error: NSError?) {
        let taskResult = taskViewController.result
        let results = taskViewController.dictionaryWithTaskResult(taskResult)
        let images = [(taskViewController as! IRLTaskViewController).shaderFrontImage , (taskViewController as! IRLTaskViewController).shaderBackImage]
        let doctorData = [results , images]
        print(doctorData)

        // Aguardando método de upload para o server

        taskViewController.dismissViewControllerAnimated(true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func taskViewController(taskViewController: ORKTaskViewController, viewControllerForStep step: ORKStep) -> ORKStepViewController? {

        var controller = ViewController.instantiateViewControllerFromStoryboard(UIStoryboard(name: "Main", bundle: nil))
        controller?.step = step
        controller?.continueButtonTitle = "Next"

        if step.identifier == "HumanBodyFront" {
            controller?.delegate = taskViewController
            controller?.bodyTypeSet(.Front)
            return controller
        } else if step.identifier == "HumanBodyBack" {
            controller?.delegate = taskViewController
            controller?.bodyTypeSet(.Back)
            return controller
        }
        
        controller = nil
        return nil
    }

}
