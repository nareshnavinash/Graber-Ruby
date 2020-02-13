require 'rake'
require 'pry'
require 'rexml/document'
require 'gmail'
require 'zip'
include REXML

# Usage Sample,
# rake email["http://jenkins.io:8080/job/Automation/133","https://github.com/nareshnavinash/graber-ruby","master","SHA Key","commiter_email@testmail.com","nareshnavinash@gmail.com;naresh@testmail.com"]
task :email, :jenkins_url, :git_url, :git_branch, :git_commit, :git_commiter_email, :to_email do |t, args|
  args.with_defaults(:jenkins_url => "http://jenkins.io:8080/job/Automation/", :git_branch => "master", :to_email => "nareshnavinash@gmail.com")
  args.with_defaults(:git_url => "https://github.com/nareshnavinash/graber-ruby", :git_commit => "SHA Key", :git_commiter_email => "commiter_email@gmail.com")
  puts args[:jenkins_url]
  puts args[:git_commit]
  puts args[:to_email]
  passed_count = 0
  failed_count = 0
  break_count = 0
  failed_testcases = []
  break_testcases = []
  Dir["reports/allure/*.xml"].each do |f|
    xmlfile = File.new("#{f}")
    xmldoc = Document.new(xmlfile)
    XPath.each(xmldoc, "ns2:test-suite/test-cases/test-case").each do |e|
      if e.attributes["status"] == "passed"
        passed_count = passed_count + 1
      elsif e.attributes["status"] == "failed"
        failed_count = failed_count + 1
        failed_testcases << XPath.first(e,"name").text
      else
        break_count = break_count + 1
        break_testcases << XPath.first(e,"name").text
      end
    end
  end
  puts "Failed - "
  puts failed_testcases
  puts "Break - \n"
  puts break_testcases
  puts passed_count, failed_count, break_count

  #Zipping the reporting folders
  File.delete("#{Pathname.pwd}/reports/html.zip") if File.exist?("#{Pathname.pwd}/reports/html.zip")
  File.delete("#{Pathname.pwd}/reports/pretty.zip") if File.exist?("#{Pathname.pwd}/reports/pretty.zip")
  directory = "#{Pathname.pwd}/reports/pretty/"
  zipfile_name = "#{Pathname.pwd}/reports/pretty.zip"
  Zip::File.open(zipfile_name, Zip::File::CREATE) do |zipfile|
    Dir[File.join(directory, '*')].each do |file|
      zipfile.add(file.sub(directory, ''), file)
    end
  end
  directory = "#{Pathname.pwd}/reports/html/"
  zipfile_name = "#{Pathname.pwd}/reports/html.zip"
  Zip::File.open(zipfile_name, Zip::File::CREATE) do |zipfile|
    Dir[File.join(directory, '*')].each do |file|
      zipfile.add(file.sub(directory, ''), file)
    end
  end

  #Email parameters
  email = "custom_email@gmail.com" #to send the email from this account
  password = "Test@123"
  to_email = args[:to_email] || "nareshnavinash@gmail.com"
  if failed_count == 0 and break_count == 0
    email_subject = "Automation - Report #{Time.now}"
  else
    email_subject = "Automation - Report #{Time.now} - Alert failure(s) found !!!"
  end
  if failed_testcases.count != 0
    final_string = ""
    failed_testcases.each do |f|
      final_string = final_string + "<li>#{f}</li>"
    end
    failed_testcases_string = "
Failed Test Cases,
<ul>
    #{final_string}
</ul>"
  else
    failed_testcases_string = ""
  end
  if break_testcases.count != 0
    final_string = ""
    break_testcases.each do |f|
      final_string = final_string + "<li>#{f}</li>"
    end
    break_testcases_string = "
Broken Test Cases,
<ul>
    #{final_string}
</ul>"
  else
    break_testcases_string = ""
  end
  email_values = {
        "To" => "#{to_email}",
        "Subject" => "#{email_subject}",
        "Cc" => "",
        "Body" => "
        <body style=\"margin: 0; padding: 0;\">


        <table cellpadding=\"0\" cellspacing=\"0\" border=\"0\" width=\"100%\" style=\"background: #f3f3f3; min-width: 350px; font-size: 1px; line-height: normal;\">
           <tr>
             <td align=\"center\" valign=\"top\">
               <!--[if (gte mso 9)|(IE)]>
                 <table border=\"0\" cellspacing=\"0\" cellpadding=\"0\">
                 <tr><td align=\"center\" valign=\"top\" width=\"750\"><![endif]-->
               <table cellpadding=\"0\" cellspacing=\"0\" border=\"0\" width=\"750\" class=\"table750\" style=\"width: 100%; max-width: 750px; min-width: 350px; background: #f3f3f3;\">
                 <tr>
                       <td class=\"mob_pad\" width=\"25\" style=\"width: 25px; max-width: 25px; min-width: 25px;\">&nbsp;</td>
                   <td align=\"center\" valign=\"top\" style=\"background: #ffffff;\">

                          <table cellpadding=\"0\" cellspacing=\"0\" border=\"0\" width=\"100%\" style=\"width: 100% !important; min-width: 100%; max-width: 100%; background: #f3f3f3;\">
                             <tr>
                                <td align=\"right\" valign=\"top\">
                                   <div class=\"top_pad\" style=\"height: 25px; line-height: 25px; font-size: 23px;\">&nbsp;</div>
                                </td>
                             </tr>
                          </table>


                          <table cellpadding=\"0\" cellspacing=\"0\" border=\"0\" width=\"100%\" style=\"width: 100% !important; min-width: 100%; max-width: 100%; background: #f3f3f3;\">
                             <tr>
                                <td align=\"right\" valign=\"top\">
                                   <div class=\"top_pad\" style=\"height: 25px; line-height: 25px; font-size: 23px;\">&nbsp;</div>
                                </td>
                             </tr>
                          </table>

                          <table cellpadding=\"0\" cellspacing=\"0\" border=\"0\" width=\"88%\" style=\"width: 88% !important; min-width: 88%; max-width: 88%;\">
                             <tr>
                                <td align=\"left\" valign=\"top\">
                                   <div style=\"height: 10px; line-height: 33px; font-size: 31px;\">&nbsp;</div>
                                   <div class=\"header\" align=\"center\">
                                     <h2 style=\"font-family: 'Source Sans Pro', Arial, Tahoma, Geneva, sans-serif; color: #3375AA; font-size: 32px; line-height: 32px;\">Automation Report</h2>
                                   </div>
                                   <div style=\"height: 10px; line-height: 33px; font-size: 31px;\">&nbsp;</div>
                                   <font face=\"'Source Sans Pro', sans-serif\" color=\"#1a1a1a\" style=\"font-size: 24px; line-height: 32px;\">
                                      <span style=\"font-family: 'Source Sans Pro', Arial, Tahoma, Geneva, sans-serif; color: #585858; font-size: 20px; line-height: 32px;\">Hi Team,</span>
                                   </font>
                                   <div style=\"height: 33px; line-height: 33px; font-size: 31px;\">&nbsp;</div>
                                   <font face=\"'Source Sans Pro', sans-serif\" color=\"#585858\" style=\"font-size: 24px; line-height: 32px;\">
                                      <span style=\"font-family: 'Source Sans Pro', Arial, Tahoma, Geneva, sans-serif; color: #585858; font-size: 20px; line-height: 32px;\">GraphQL Automation Regression Status,</span>
                                   </font>
                                   <div style=\"height: 20px; line-height: 20px; font-size: 20px;\">&nbsp;</div>
                                   <table cellpadding=\"0\" cellspacing=\"0\" border=\"0\" width=\"88%\" style=\"width: 88% !important; min-width: 88%; max-width: 88%;\">
                                      <tr>
                                         <td align=\"left\" valign=\"top\">
                                            <font face=\"'Source Sans Pro', sans-serif\" color=\"#585858\" style=\"font-size: 24px; line-height: 32px;\">
                                               <span style=\"font-family: 'Source Sans Pro', Arial, Tahoma, Geneva, sans-serif; color: #585858; font-size: 18px; line-height: 32px;\">Passed Test Case count :</span>
                                            </font>
                                         </td>
                                         <td align=\"left\" valign=\"top\">
                                            <font face=\"'Source Sans Pro', sans-serif\" color=\"#585858\" style=\"font-size: 24px; line-height: 32px;\">
                                               <span style=\"font-family: 'Source Sans Pro', Arial, Tahoma, Geneva, sans-serif; color: #0E9C4A; font-size: 18px; line-height: 32px;\">#{passed_count}</span>
                                            </font>
                                         </td>
                                      </tr>
                                      <tr>
                                         <td align=\"left\" valign=\"top\">
                                            <font face=\"'Source Sans Pro', sans-serif\" color=\"#585858\" style=\"font-size: 24px; line-height: 32px;\">
                                               <span style=\"font-family: 'Source Sans Pro', Arial, Tahoma, Geneva, sans-serif; color: #585858; font-size: 18px; line-height: 32px;\">Failed Test Case count :</span>
                                            </font>
                                         </td>
                                         <td align=\"left\" valign=\"top\">
                                            <font face=\"'Source Sans Pro', sans-serif\" color=\"#585858\" style=\"font-size: 24px; line-height: 32px;\">
                                               <span style=\"font-family: 'Source Sans Pro', Arial, Tahoma, Geneva, sans-serif; color: #B2230F; font-size: 18px; line-height: 32px;\">#{failed_count}</span>
                                            </font>
                                         </td>
                                      </tr>
                                      <tr>
                                         <td align=\"left\" valign=\"top\">
                                            <font face=\"'Source Sans Pro', sans-serif\" color=\"#585858\" style=\"font-size: 24px; line-height: 32px;\">
                                               <span style=\"font-family: 'Source Sans Pro', Arial, Tahoma, Geneva, sans-serif; color: #585858; font-size: 18px; line-height: 32px;\">Broken Test Case count :</span>
                                            </font>
                                         </td>
                                         <td align=\"left\" valign=\"top\">
                                            <font face=\"'Source Sans Pro', sans-serif\" color=\"#585858\" style=\"font-size: 24px; line-height: 32px;\">
                                               <span style=\"font-family: 'Source Sans Pro', Arial, Tahoma, Geneva, sans-serif; color: #E6C404; font-size: 18px; line-height: 32px;\">#{break_count}</span>
                                            </font>
                                         </td>
                                      </tr>
                                      <tr>
                                         <td align=\"left\" valign=\"top\">
                                            <font face=\"'Source Sans Pro', sans-serif\" color=\"#585858\" style=\"font-size: 24px; line-height: 32px;\">
                                               <span style=\"font-family: 'Source Sans Pro', Arial, Tahoma, Geneva, sans-serif; color: #585858; font-size: 18px; line-height: 32px;\">Run Completed at :</span>
                                            </font>
                                         </td>
                                         <td align=\"left\" valign=\"top\">
                                            <font face=\"'Source Sans Pro', sans-serif\" color=\"#585858\" style=\"font-size: 24px; line-height: 32px;\">
                                               <span style=\"font-family: 'Source Sans Pro', Arial, Tahoma, Geneva, sans-serif; color: #130145; font-size: 18px; line-height: 32px;\">#{Time.now}</span>
                                            </font>
                                         </td>
                                      </tr>
                                   </table>
                                   <div style=\"height: 33px; line-height: 33px; font-size: 31px;\">&nbsp;</div>
                                   <font face=\"'Source Sans Pro', sans-serif\" color=\"#585858\" style=\"font-size: 24px; line-height: 32px;\">
                                      <span style=\"font-family: 'Source Sans Pro', Arial, Tahoma, Geneva, sans-serif; color: #585858; font-size: 18px; line-height: 32px;\">HTML Reports and Command line logs are attached for reference. Below are the few parameters that are responsible for this job trigger. If any failures or broken cases found in the result kindly trace back from the last commit ID with the last commited user.</span>
                                   </font>
                                   <div style=\"height: 20px; line-height: 20px; font-size: 31px;\">&nbsp;</div>
                                   <table cellpadding=\"0\" cellspacing=\"0\" border=\"0\" width=\"88%\" style=\"width: 88% !important; min-width: 88%; max-width: 88%;\">
                                      <tr>
                                         <td align=\"left\" valign=\"top\">
                                            <font face=\"'Source Sans Pro', sans-serif\" color=\"#585858\" style=\"font-size: 24px; line-height: 32px;\">
                                               <span style=\"font-family: 'Source Sans Pro', Arial, Tahoma, Geneva, sans-serif; color: #585858; font-size: 17px; line-height: 32px;\">Jenkins URL:</span>
                                            </font>
                                         </td>
                                         <td align=\"left\" valign=\"top\">
                                            <font face=\"'Source Sans Pro', sans-serif\" color=\"#585858\" style=\"font-size: 24px; line-height: 32px;\">
                                               <a href=\"#{args[:jenkins_url]}\" style=\"font-family: 'Source Sans Pro', Arial, Tahoma, Geneva, sans-serif; color: #130145; font-size: 17px; line-height: 32px;\">navigate_to_jenkins</a>
                                            </font>
                                         </td>
                                      </tr>
                                      <tr>
                                         <td align=\"left\" valign=\"top\">
                                            <font face=\"'Source Sans Pro', sans-serif\" color=\"#585858\" style=\"font-size: 24px; line-height: 32px;\">
                                               <span style=\"font-family: 'Source Sans Pro', Arial, Tahoma, Geneva, sans-serif; color: #585858; font-size: 17px; line-height: 32px;\">Git Branch:</span>
                                            </font>
                                         </td>
                                         <td align=\"left\" valign=\"top\">
                                            <font face=\"'Source Sans Pro', sans-serif\" color=\"#585858\" style=\"font-size: 24px; line-height: 32px;\">
                                               <span style=\"font-family: 'Source Sans Pro', Arial, Tahoma, Geneva, sans-serif; color: #130145; font-size: 17px; line-height: 32px;\">#{args[:git_branch]}</span>
                                            </font>
                                         </td>
                                      </tr>
                                      <tr>
                                         <td align=\"left\" valign=\"top\">
                                            <font face=\"'Source Sans Pro', sans-serif\" color=\"#585858\" style=\"font-size: 24px; line-height: 32px;\">
                                               <span style=\"font-family: 'Source Sans Pro', Arial, Tahoma, Geneva, sans-serif; color: #585858; font-size: 17px; line-height: 32px;\">Last Commit ID:</span>
                                            </font>
                                         </td>
                                         <td align=\"left\" valign=\"top\">
                                            <font face=\"'Source Sans Pro', sans-serif\" color=\"#585858\" style=\"font-size: 24px; line-height: 32px;\">
                                               <span style=\"font-family: 'Source Sans Pro', Arial, Tahoma, Geneva, sans-serif; color: #130145; font-size: 17px; line-height: 32px;\">#{args[:git_commit]}</span>
                                            </font>
                                         </td>
                                      </tr>
                                      <tr>
                                         <td align=\"left\" valign=\"top\">
                                            <font face=\"'Source Sans Pro', sans-serif\" color=\"#585858\" style=\"font-size: 24px; line-height: 32px;\">
                                               <span style=\"font-family: 'Source Sans Pro', Arial, Tahoma, Geneva, sans-serif; color: #585858; font-size: 17px; line-height: 32px;\">Last Commit by:</span>
                                            </font>
                                         </td>
                                         <td align=\"left\" valign=\"top\">
                                            <font face=\"'Source Sans Pro', sans-serif\" color=\"#585858\" style=\"font-size: 24px; line-height: 32px;\">
                                               <span style=\"font-family: 'Source Sans Pro', Arial, Tahoma, Geneva, sans-serif; color: #130145; font-size: 17px; line-height: 32px;\">#{args[:git_commiter_email]}</span>
                                            </font>
                                         </td>
                                      </tr>
                                   </table>
                                   <div style=\"height: 33px; line-height: 33px; font-size: 31px;\">&nbsp;</div>
                                   <font face=\"'Source Sans Pro', sans-serif\" color=\"#585858\" style=\"font-size: 24px; line-height: 32px;\">
                                      <span style=\"font-family: 'Source Sans Pro', Arial, Tahoma, Geneva, sans-serif; color: #585858; font-size: 18px; line-height: 32px;\">Follow the following Link for detailed analysis in allure,</span>
                                   </font>
                                   <div style=\"height: 10px; line-height: 10px; font-size: 10px;\">&nbsp;</div>
                                   <table cellpadding=\"0\" cellspacing=\"0\" border=\"0\" width=\"88%\" style=\"width: 88% !important; min-width: 88%; max-width: 88%;\">
                                      <tr>
                                         <td align=\"left\" valign=\"top\">
                                            <table class=\"mob_btn\" cellpadding=\"0\" cellspacing=\"0\" border=\"0\" style=\"background: #27cbcc; border-radius: 4px;\">
                                               <tr>
                                                  <td align=\"center\" valign=\"top\">
                                                     <a href=\"#{args[:jenkins_url]}allure/\" target=\"_blank\" style=\"display: block; border: 1px solid #27cbcc; border-radius: 4px; padding: 4px 8px; font-family: 'Source Sans Pro', Arial, Verdana, Tahoma, Geneva, sans-serif; color: #ffffff; font-size: 20px; line-height: 30px; text-decoration: none; white-space: nowrap; font-weight: 600;\">
                                                        <font face=\"'Source Sans Pro', sans-serif\" color=\"#ffffff\" style=\"font-size: 20px; line-height: 30px; text-decoration: none; white-space: nowrap; font-weight: 600;\">
                                                           <span style=\"font-family: 'Source Sans Pro', Arial, Verdana, Tahoma, Geneva, sans-serif; color: #ffffff; font-size: 20px; line-height: 30px; text-decoration: none; white-space: nowrap; font-weight: 600;\">Allure&nbsp;Report</span>
                                                        </font>
                                                     </a>
                                                  </td>
                                               </tr>
                                            </table>
                                         </td>
                                      </tr>
                                   </table>
                                   <div style=\"height: 45px; line-height: 10px; font-size: 10px;\">&nbsp;</div>
                                   <font face=\"'Source Sans Pro', sans-serif\" color=\"#585858\" style=\"font-size: 24px; line-height: 32px;\">
                                      <span style=\"font-family: 'Source Sans Pro', Arial, Tahoma, Geneva, sans-serif; color: #585858; font-size: 16px; line-height: 32px;\">This email is auto-triggered from Jenkins Automation Job, for any queries please contact </span>
                                      <a href=\"mailto:nareshnavinash@gmail.com\" style=\"font-family: 'Source Sans Pro', Arial, Tahoma, Geneva, sans-serif; color: #585858; font-size: 16px; line-height: 32px;\"> nareshnavinash@gmail.com</a>
                                      <span style=\"font-family: 'Source Sans Pro', Arial, Tahoma, Geneva, sans-serif; color: #585858; font-size: 16px; line-height: 32px;\"> or </span>
                                      <a href=\"mailto:nareshsekar@zoho.com\" style=\"font-family: 'Source Sans Pro', Arial, Tahoma, Geneva, sans-serif; color: #585858; font-size: 16px; line-height: 32px;\">nareshsekar@zoho.com.</a>
                                   </font>

                                   <div style=\"height: 33px; line-height: 33px; font-size: 31px;\">&nbsp;</div>
                                   <font face=\"'Source Sans Pro', sans-serif\" color=\"#585858\" style=\"font-size: 24px; line-height: 32px;\">
                                      <span style=\"font-family: 'Source Sans Pro', Arial, Tahoma, Geneva, sans-serif; color: #585858; font-size: 16px; line-height: 32px;\">#{failed_testcases_string}</span>
                                   </font>
                                   <div style=\"height: 1px; line-height: 1px; font-size: 31px;\">&nbsp;</div>
                                   <font face=\"'Source Sans Pro', sans-serif\" color=\"#585858\" style=\"font-size: 24px; line-height: 32px;\">
                                      <span style=\"font-family: 'Source Sans Pro', Arial, Tahoma, Geneva, sans-serif; color: #585858; font-size: 16px; line-height: 32px;\">#{break_testcases_string}</span>
                                   </font>
                                   <div style=\"height: 33px; line-height: 33px; font-size: 31px;\">&nbsp;</div>
                                </td>
                             </tr>
                          </table>
                          <table cellpadding=\"0\" cellspacing=\"0\" border=\"0\" width=\"90%\" style=\"width: 90% !important; min-width: 90%; max-width: 90%; border-width: 1px; border-style: solid; border-color: #e8e8e8; border-bottom: none; border-left: none; border-right: none;\">
                             <tr>
                                <td align=\"left\" valign=\"top\">
                                   <div style=\"height: 15px; line-height: 15px; font-size: 13px;\">&nbsp;</div>
                                </td>
                             </tr>
                          </table>

                          <table cellpadding=\"0\" cellspacing=\"0\" border=\"0\" width=\"88%\" style=\"width: 88% !important; min-width: 88%; max-width: 88%;\">
                             <tr>
                                <td class=\"mob_center\" align=\"left\" valign=\"top\">
                                   <div style=\"height: 10px; line-height: 10px; font-size: 11px;\">&nbsp;</div>
                                   <font face=\"'Source Sans Pro', sans-serif\" color=\"#000000\" style=\"font-size: 19px; line-height: 23px; font-weight: 600;\">
                                      <span style=\"font-family: 'Source Sans Pro', Arial, Tahoma, Geneva, sans-serif; color: #7f7f7f; font-size: 19px; line-height: 23px;\">Thanks,</span>
                                   </font>
                                   <div style=\"height: 1px; line-height: 1px; font-size: 1px;\">&nbsp;</div>
                                   <font face=\"'Source Sans Pro', sans-serif\" color=\"#7f7f7f\" style=\"font-size: 19px; line-height: 23px;\">
                                      <span style=\"font-family: 'Source Sans Pro', Arial, Tahoma, Geneva, sans-serif; color: #000000; font-size: 19px; line-height: 23px; font-weight: 600;\">SDET Team.</span>
                                   </font>
                                   <div style=\"height: 25px; line-height: 20px; font-size: 15px;\">&nbsp;</div>
                                </td>
                             </tr>
                          </table>

                          <table cellpadding=\"0\" cellspacing=\"0\" border=\"0\" width=\"100%\" style=\"width: 100% !important; min-width: 100%; max-width: 100%; background: #f3f3f3;\">
                             <tr>
                                <td align=\"center\" valign=\"top\">
                                   <div style=\"height: 34px; line-height: 34px; font-size: 32px;\">&nbsp;</div>
                                   <table cellpadding=\"0\" cellspacing=\"0\" border=\"0\" width=\"88%\" style=\"width: 88% !important; min-width: 88%; max-width: 88%;\">
                                      <tr>
                                         <td align=\"center\" valign=\"top\">
                                            <font face=\"'Source Sans Pro', sans-serif\" color=\"#868686\" style=\"font-size: 17px; line-height: 20px;\">
                                               <span style=\"font-family: 'Source Sans Pro', Arial, Tahoma, Geneva, sans-serif; color: #868686; font-size: 17px; line-height: 20px;\">Copyright &copy; 2020 Naresh Sekar. All&nbsp;Rights&nbsp;Reserved. Confidential&nbsp;attachments!</span>
                                            </font>
                                            <div style=\"height: 2px; line-height: 2px; font-size: 32px;\">&nbsp;</div>
                                            <font face=\"'Source Sans Pro', sans-serif\" color=\"#868686\" style=\"font-size: 17px; line-height: 20px;\">
                                               <span style=\"font-family: 'Source Sans Pro', Arial, Tahoma, Geneva, sans-serif; color: #868686; font-size: 17px; line-height: 20px;\">Beware Before Forwarding this e-mail!</span>
                                            </font>
                                            <div style=\"height: 3px; line-height: 3px; font-size: 1px;\">&nbsp;</div>
                                            <font face=\"'Source Sans Pro', sans-serif\" color=\"#1a1a1a\" style=\"font-size: 17px; line-height: 20px;\">
                                               <span style=\"font-family: 'Source Sans Pro', Arial, Tahoma, Geneva, sans-serif; color: #1a1a1a; font-size: 17px; line-height: 20px;\"><a href=\"mailto:nareshnavinash@gmail.com\" target=\"_blank\" style=\"font-family: 'Source Sans Pro', Arial, Tahoma, Geneva, sans-serif; color: #1a1a1a; font-size: 17px; line-height: 20px; text-decoration: none;\">nareshnavinash@gmail.com</a>
                                            </font>
                                            <div style=\"height: 35px; line-height: 35px; font-size: 33px;\">&nbsp;</div>
                                         </td>
                                      </tr>
                                   </table>
                                </td>
                             </tr>
                          </table>

                       </td>
                       <td class=\"mob_pad\" width=\"25\" style=\"width: 25px; max-width: 25px; min-width: 25px;\">&nbsp;</td>
                    </tr>
                 </table>
                 <!--[if (gte mso 9)|(IE)]>
                 </td></tr>
                 </table><![endif]-->
              </td>
           </tr>
        </table>
        </body>
",
        "Body Type" => "html",
        "Attachments" => "reports/html/*.html"
    }
    puts "Send email to below values #{email_values.to_s}"
    @current_instance = Gmail.new(email,password)
    @current_instance.deliver do
      to email_values["To"] if email_values["To"] != nil
      cc email_values["Cc"] if email_values["Cc"] != nil
      bcc email_values["Bcc"] if email_values["Bcc"] != nil
      subject email_values["Subject"] if email_values["Subject"] != nil
      if email_values["Body Type"] == "text" && email_values["Body Type"] != nil
        text_part do
          body email_values["Body"]
        end
      elsif email_values["Body Type"] == "html" && email_values["Body Type"] != nil
        html_part do
          content_type 'text/html; charset=UTF-8'
          body email_values["Body"]
        end
      else
        body email_values["Body"] if email_values["Body"] != nil
      end
      if email_values["Attachments"] != nil
        attachments_values = Dir["reports/*.zip"]
        attachments_values.each do |attachment_value|
          file_path = "#{Pathname.pwd}/#{attachment_value}"
          add_file file_path
        end
      end
    end
    puts "Logout the gmail instance"
    @current_instance.logout
end
