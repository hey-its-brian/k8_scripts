###########################################
##  Author: Brian Meyer                  ##
##  Agency: DCHBX                        ##
##  Use: To build the command used       ##
##      to download files from k8 pods   ##
##  Created: 7/26/23                     ##
##  Updated: 7/26/23                     ##
###########################################


class String
    def red;            "\e[31m#{self}\e[0m" end
    def green;          "\e[32m#{self}\e[0m" end
    def cyan;           "\e[36m#{self}\e[0m" end
    def bold;           "\e[1m#{self}\e[22m" end
    def italic;         "\e[3m#{self}\e[23m" end
end

def dl_builder
    # Namespace choice
    puts "\n\n1. NAMESPACE:".green.bold
    puts "\tChoose the Namespace you wish to download from:
        \t1. hbxit
        \t2. preprod
        \t3. prod".cyan
    print "\tEnter choice (1,2,3): ".cyan.bold
    namespace_choice = gets.chomp

    if namespace_choice == '1'
        namespace = 'hbxit '
    elsif namespace_choice == '2'
        namespace = 'preprod '
    elsif namespace_choice == '3'
        namespace = 'prod '
    else
        "*****  Invalid Entry. Please run again and choose 1, 2, or 3.  *****".red
        return
    end 

    # Pod Name entry
    puts "2. POD NAME:".green.bold
    puts "\tEnter the Pod Name you wish to connect to".cyan
    puts "\tExample: enroll-deploy-tasks-prod-xxxxxx-xxxxx".cyan.italic
    print "\tPod Name: ".cyan.bold
    pod_name = gets.chomp

    # Folder location
    puts "3. REMOTE POD FOLDER LOCATION:".green.bold
    puts "\tDefault pod folder for reports is /enroll/tmp/hbx_reports/".cyan
    print "\tIs this correct? (y or n): ".cyan.bold
    folder_choice = gets.chomp.downcase

    if folder_choice == 'y'
        remote_folder = '/enroll/tmp/hbx_reports/'
    else
        puts "\n\tEnter the folder location for your file.".cyan
        puts "\tInclude / (slash) before AND after the folder location (See above for example)".cyan.italic
        print "\tFolder location: ".cyan.bold
        remote_folder = gets.chomp.downcase
    end

    puts "4. File will be downloaded to your Desktop folder. (~/Desktop/)\n\n".green.bold
    local_folder = "~/Desktop/"

    puts "5. FILE NAME:".green.bold
    print "\tEnter the file name including extension that you wish to download: ".cyan.bold
    file_name = gets.chomp.downcase

    puts "RESULT:".green.bold
    puts "\tRun this command in your local console to download the file:".green
    puts "\n\tkubectl cp #{namespace}#{pod_name}:#{remote_folder}#{file_name} #{local_folder}#{file_name}".green.bold
end


