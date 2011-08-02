require '../lib/recordandplayback'
require 'rubygems'
require 'yaml'
require 'fileutils'
require 'builder'


def archive_recorded_meeting()
  `ruby archive/archive.rb`
end

def process_archived_meeting(recording_dir)
  done_files = Dir.glob("#{recording_dir}/status/archived/*.done")	
  done_files.each do |df|
    match = /(.*).done/.match df.sub(/.+\//, "")
    meeting_id = match[1]
    
    # Execute all the scripts under the steps directory.
    # This script must be invoked from the scripts directory for the PATH to be resolved.
    Dir.glob("#{Dir.pwd}/process/*.rb").sort.each do |file|
      #  BigBlueButton.logger.info("Executing #{file}\n")  
	#IO.popen("ruby #{file} -m #{meeting_id}")
	#Process.wait
	#puts "********** #{$?.exitstatus} #{$?.exited?} #{$?.success?}********************"
      command = "ruby #{file} -m #{meeting_id}"
      BigBlueButton.execute(command)

    end
  end	
end

def publish_processed_meeting(recording_dir)
  done_files = Dir.glob("#{recording_dir}/status/processed/*.done")
  
  done_files.each do |df|
    match = /(.*).done/.match df.sub(/.+\//, "")
    meeting_id = match[1]
    
	# After a meeting is processed, a new directory in published for the meeting is created
	published_dir = props['published_dir'] + "/#{meeting_id}"
	create_metadata_file(recording_dir,published_dir,meeting_id)
	
	
    # Execute all the scripts under the steps directory.
    # This script must be invoked from the scripts directory for the PATH to be resolved.
    Dir.glob("#{Dir.pwd}/publish/*.rb").sort.each do |file|
      #  BigBlueButton.logger.info("Executing #{file}\n")  
      #IO.popen("ruby #{file} -m #{meeting_id}")
      #Process.wait
      #puts "********** #{$?.exitstatus} #{$?.exited?} #{$?.success?}********************"
      command = "ruby #{file} -m #{meeting_id}"
      BigBlueButton.execute(command)

    end
  end	
end

def create_metadata_file(recording_dir,published_dir,meeting_id)
	if not FileTest.directory?(published_dir)
		FileUtils.mkdir_p published_dir
		
		raw_archive_dir = "#{recording_dir}/raw/#{meeting_id}"
		metavalues=BigBlueButton::Events.get_meeting_metadata("#{raw_archive_dir}/events.xml")
		# Create metadata.xml
		b = Builder::XmlMarkup.new(:indent => 2)		 
		metaxml = b.recording {
		  b.recordID(meeting_id)
		  b.meetingID(metavalues.delete("meetingID"))
		  b.name(metavalues.delete("meetingName"))
		  b.published(true)
		  b.start_time(Time.at((metavalues.delete("meetingStart").to_f/1000.0)).utc)
		  b.end_time(Time.at((metavalues.delete("meetingEnd").to_f/1000.0)).utc)
		  b.metadata {
		  	metavalues.each { |k,v| b.method_missing(k,v) }
	  	  }
		  b.playback {
		  
	  	  }
		  			
		}
		
		puts "writing metadata to #{published_dir}/metadata.xml" 
		metadata_xml = File.new("#{published_dir}/metadata.xml","w")
		metadata_xml.write(metaxml)
		metadata_xml.close
	end
end

#  if not FileTest.directory?("#{archive_dir}/#{meeting_id}")
#    puts "#{archive_dir}/#{meeting_id} does not exist."
#    
#  else
#    puts "#{archive_dir}/#{meeting_id} exists."
#    `ruby process/simple.rb -m #{meeting_id}`
#    `ruby publish/simple.rb -m #{meeting_id}`
#  end  
  


# TODO:
# 1. Check if meeting-id has corresponding dir in /var/bigbluebutton/archive
# 2. If yest, return
# 3. If not, archive the recording
# 4. Add entry in /var/bigbluebutton/status/archived/<meeting-id>.done file


# Execute all the scripts under the steps directory.
# This script must be invoked from the scripts directory for the PATH to be resolved.
#Dir.glob("#{Dir.pwd}/archive/steps/*.rb").sort.each do |file|
#  BigBlueButton.logger.info("Executing #{file}\n")  
#  IO.popen("ruby #{file} -m #{meeting_id}")
#  Process.wait
  #puts "********** #{$?.exitstatus} #{$?.exited?} #{$?.success?}********************"
#end



props = YAML::load(File.open('bigbluebutton.yml'))
recording_dir = props['recording_dir']
archive_recorded_meeting()
process_archived_meeting(recording_dir)
publish_processed_meeting(recording_dir)

