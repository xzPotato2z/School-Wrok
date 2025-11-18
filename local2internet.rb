# Local2Internet - macOS Version

# Author       : Potato
# Github       : 
# Description  : Host a website at localhost and make it publicly available all over the internet

black="\033[0;30m"
red="\033[0;31m"
green="\033[0;32m"
yellow="\033[0;33m"  
blue="\033[0;34m"
purple="\033[0;35m"
cyan="\033[0;36m"
white="\033[0;37m"

logo="""
#{red}
▒█░░░ █▀▀█ █▀▀ █▀▀█ █░░ █▀█ ▀█▀ █▀▀▄ ▀▀█▀▀ █▀▀ █▀▀█ █▀▀▄ █▀▀ ▀▀█▀▀ 
#{yellow}▒█░░░ █░░█ █░░ █▄▄█ █░░ ░▄▀ ▒█░ █░░█ ░░█░░ █▀▀ █▄▄▀ █░░█ █▀▀ ░░█░░ 
#{green}▒█▄▄█ ▀▀▀▀ ▀▀▀ ▀░░▀ ▀▀▀ █▄▄ ▄█▄ ▀░░▀ ░░▀░░ ▀▀▀ ▀░▀▀ ▀░░▀ ▀▀▀ ░░▀░░
#{blue}                                                    [By Potato - MacOS]
"""

ask = green + '[' + white + '?' + green + '] '+ yellow
success = green + '[' + white + '√' + green + '] '
error = red + '[' + white + '!' + red + '] '
info= yellow + '[' + white + '+' + yellow + '] '+ cyan
pw= yellow + '[' + white + '+' +yellow + ']'+' Please Wait!'

puts pw
root=`echo $HOME`.strip
checkphp=`pgrep php`
checkngrok=`pgrep ngrok`
checkcf=`pgrep cloudflared`
checkwt=`pgrep wget`
checkcurl=`pgrep curl`
checknode=`pgrep node`
checkpy=`pgrep python`
checkloclx=`pgrep loclx`

# Check if Homebrew is installed
homebrew=`which brew 2>/dev/null`.strip
if homebrew==""
    puts "\n#{error}Homebrew is not installed!"
    puts "#{info}Please install Homebrew from https://brew.sh"
    puts "#{info}Run: /bin/bash -c \"$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
    exit
end

# Check installations using brew list
inpy=`brew list python 2>/dev/null`
inphp=`brew list php 2>/dev/null`
inwget=`brew list wget 2>/dev/null`
incurl=`which curl`.strip  # curl is pre-installed on macOS
innode=`brew list node 2>/dev/null`

arc=`uname -m`.strip
system("stty -echoctl")

# Install required packages
if inpy==""
    puts "\n#{info}Installing Python......."
    system("brew install python")
end
if inphp==""
    puts "\n#{info}Installing PHP......."
    system("brew install php")
end
if inwget==""
    puts "\n#{info}Installing Wget......."
    system("brew install wget")
end
if incurl==""
    puts "\n#{error}Curl should be pre-installed on macOS"
    exit
end
if innode==""
    puts "\n#{info}Installing NodeJS......."
    system("brew install node")
end

# Kill existing processes
if checkphp!=""
    system("killall php")
end
if checkngrok!=""
    system("killall ngrok")
end
if checkcf!=""
    system("killall cloudflared")
end
if checkwt!=""
    system("killall wget")
end
if checkcurl!=""
    system("killall curl")
end
# Don't kill python3 if Flask is running on port 5000
flask_check=`curl -s --head -w %{http_code} 127.0.0.1:5000 -o /dev/null 2>/dev/null`.strip
if checkpy!="" and (flask_check == "" or flask_check.include?"000")
    system("killall python3")
end
if checknode!=""
    system("killall node")
end
if checkloclx!=""
    system("killall loclx")
end

# Verify installations
inpy2=`brew list python 2>/dev/null`
inphp2=`brew list php 2>/dev/null`
inwget2=`brew list wget 2>/dev/null`
innode2=`brew list node 2>/dev/null`

if inpy2==""
    puts "\n#{error}Error! Python can't be installed!"
    exit
end
if inphp2==""
    puts "\n#{error}Error! PHP can't be installed!"
    exit
end
if inwget2==""
    puts "\n#{error}Error! Wget can't be installed!"
    exit
end
if innode2==""
    puts "\n#{error}Error! NodeJS can't be installed!"
    exit
end

# Install http-server
begin
nodecheck=`npm list -g --depth=0 | grep -o http-server`
if not nodecheck.include?"http-server"
    puts "\n#{info}Installing Http-server......."
    system("npm install -g http-server")
end
rescue
    puts "\n#{info}Installing Http-server......."
    system("npm install -g http-server")
end

# Check if Flask is installed
flask_check=`python3 -c "import flask" 2>&1`.strip
if flask_check != ""
    puts "\n#{info}Installing Flask......."
    system("pip3 install flask > /dev/null 2>&1")
end

# Download ngrok
if not File.file?(root+"/.ngrokfolder/ngrok")
while true
    system("rm -rf ngrok.zip ngrok")
    puts "\n#{info}Downloading Ngrok......."
    if arc.include?"arm64"
        system("wget -q --show-progress https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-darwin-arm64.zip -O ngrok.zip")
    else
        system("wget -q --show-progress https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-darwin-amd64.zip -O ngrok.zip")
    end
    system("unzip -q ngrok.zip && rm -rf ngrok.zip")
    break
end
system("mkdir -p $HOME/.ngrokfolder && mv -f ngrok $HOME/.ngrokfolder && chmod +x $HOME/.ngrokfolder/ngrok")
end

# Download cloudflared
if not File.file?(root+"/.cffolder/cloudflared")
    system("rm -rf cloudflared")
while true
    puts "\n#{info}Downloading Cloudflared......."
    if arc.include?"arm64"
        system("wget -q --show-progress https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-darwin-arm64.tgz -O cloudflared.tgz")
        system("tar -xzf cloudflared.tgz && rm -rf cloudflared.tgz")
    else
        system("wget -q --show-progress https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-darwin-amd64.tgz -O cloudflared.tgz")
        system("tar -xzf cloudflared.tgz && rm -rf cloudflared.tgz")
    end
    break
end
system("mkdir -p $HOME/.cffolder && mv -f cloudflared $HOME/.cffolder && chmod +x $HOME/.cffolder/cloudflared")
end

# Download loclx
if not File.file?(root+"/.loclxfolder/loclx")
while true
    system("rm -rf loclx.zip loclx")
    puts "\n#{info}Downloading Loclx......."
    if arc.include?"arm64"
        system("wget -q --show-progress https://lxpdownloads.sgp1.digitaloceanspaces.com/cli/loclx-darwin-arm64.zip -O loclx.zip")
    else
        system("wget -q --show-progress https://lxpdownloads.sgp1.digitaloceanspaces.com/cli/loclx-darwin-amd64.zip -O loclx.zip")
    end
    system("unzip -q loclx.zip && rm -rf loclx.zip")
    break
end
system("mkdir -p $HOME/.loclxfolder && mv -f loclx $HOME/.loclxfolder && chmod +x $HOME/.loclxfolder/loclx")
end

# Set directory to Flask app location
path = "/Users/potato/Desktop/school type"

# Function to find an available port
def find_available_port(start_port = 5000, max_attempts = 20)
    (start_port..start_port + max_attempts).each do |p|
        check = `lsof -ti:#{p} 2>/dev/null`.strip
        if check == ""
            return p
        end
    end
    return nil
end

# Find available port
port = find_available_port(5000, 20)
if port.nil?
    puts "\n#{error}Could not find an available port!"
    exit
end
port = port.to_s

# Check if Flask is already running on any common port
flask_running_port = nil
[5000, 5001, 5002, 5003, 5004, 8080, 8088].each do |p|
    flask_running = `curl -s --head -w %{http_code} 127.0.0.1:#{p} -o /dev/null 2>/dev/null`.strip
    if flask_running != "" and not flask_running.include?"000"
        flask_running_port = p.to_s
        port = flask_running_port
        break
    end
end

# Set defaults
host = "1"  # Python

puts logo+"\n\n"
puts "#{info}Auto-configuring with defaults..."

# Display Python and Flask information
python_version = `python3 --version 2>&1`.strip
if python_version != ""
    puts "#{info}Python: #{green}#{python_version}#{cyan}"
else
    puts "#{error}Python3 not found!"
end

flask_version = `python3 -c "import flask; print(flask.__version__)" 2>&1`.strip
if flask_version != "" and not flask_version.include?"Error"
    puts "#{info}Flask: #{green}v#{flask_version}#{cyan}"
else
    puts "#{error}Flask not installed!"
end

puts "#{info}Directory: #{green}#{path}#{cyan}"
puts "#{info}Protocol: #{green}Flask/Python#{cyan}"
puts "#{info}Port: #{green}#{port}#{cyan}"
flask_check = `curl -s --head -w %{http_code} 127.0.0.1:#{port} -o /dev/null 2>/dev/null`.strip
if flask_check != "" and not flask_check.include?"000"
    puts "#{info}Status: #{green}Flask server detected and running on port #{port}#{cyan}\n"
else
    puts "#{info}Status: #{yellow}Will start Flask server on port #{port}#{cyan}\n"
end
system("sleep 2")

# Main loop (for About/Exit options)
while true
system("clear")
puts logo+"\n\n"
print ask+"Choose one of the following:\n\n1.Start (Auto-configured)\n2.About\n0.Exit\n(Default: #{green}1 - Start#{yellow})---> "+ green
type=gets.chomp
# Auto-start if Enter is pressed or "1" is selected
if type=="" or type=="1"
    type="1"
end
case type
when "1"
# Use auto-detected values (already set above)

system("clear")
puts logo+"\n\n"

# Display Python and Flask information
python_version = `python3 --version 2>&1`.strip
if python_version != ""
    puts "#{info}Python: #{green}#{python_version}#{cyan}"
else
    puts "#{error}Python3 not found!"
end

flask_version = `python3 -c "import flask; print(flask.__version__)" 2>&1`.strip
if flask_version != "" and not flask_version.include?"Error"
    puts "#{info}Flask: #{green}v#{flask_version}#{cyan}"
else
    puts "#{error}Flask not installed!"
end

puts "#{info}Directory: #{green}#{path}#{cyan}"
puts "#{info}Protocol: #{green}Flask/Python#{cyan}"
puts "#{info}Port: #{green}#{port}#{cyan}\n"

system("rm -rf $HOME/.cffolder/.log.txt")
system("rm -rf $HOME/.loclxfolder/.log.txt")

# Check if Flask is already running
flask_running = `curl -s --head -w %{http_code} 127.0.0.1:#{port} -o /dev/null 2>/dev/null`.strip
if flask_running != "" and not flask_running.include?"000"
    puts "\n#{info}Flask server already running on port #{port}!"
    puts "#{success}Using existing Flask server...\n"
    system("sleep 2")
else
    puts "\n#{info}Starting Flask server on port #{port}......."
    # Check if app.py exists in the Flask directory
    if File.file?("#{path}/app.py")
        puts "#{info}Found app.py, starting Flask application..."
        system("cd #{path} && FLASK_PORT=#{port} python3 app.py #{port} > /dev/null 2>&1 &")
    else
        puts "#{error}app.py not found in #{path}!"
        puts "#{info}Please make sure your Flask app (app.py) is in the correct directory."
        puts "#{info}Or start Flask manually: cd #{path} && python3 app.py"
        puts "#{info}Then run this script again.\n"
        exit
    end
    
    # Wait for Flask to start
    system("sleep 3")
    status=`curl -s --head -w %{http_code} 127.0.0.1:#{port} -o /dev/null 2>/dev/null`.strip
    if status.include?"000" or status == ""
        puts "\n#{error}Flask server failed to start on port #{port}!"
        puts "#{info}Please check if Flask is installed: pip3 install flask"
        puts "#{info}Or start Flask manually: cd #{path} && python3 app.py #{port}"
        exit
    else
        puts "\n#{success}Flask server started successfully on port #{port}!\n"
        system("sleep 2")
    end
end

puts "\n#{info}Starting tunnelers......."
puts "#{info}Tunneling Flask app on port #{green}#{port}#{cyan}...\n"
system("cd $HOME/.ngrokfolder && ./ngrok http #{port} > /dev/null 2>&1 &")
system("cd $HOME/.cffolder && ./cloudflared tunnel -url 127.0.0.1:#{port} --logfile .log.txt > /dev/null 2>&1 &")
system("cd $HOME/.loclxfolder && ./loclx tunnel http --to :#{port} > .log.txt 2> /dev/null &")

system("sleep 8")

ngroklink=`curl -s -N http://127.0.0.1:4040/api/tunnels 2>/dev/null | grep -oE "https://[a-z0-9-]+\.ngrok(-free)?\.(io|dev)" | head -1`.strip
if ngroklink.include?"ngrok"
    ngrokcheck=true
else
    ngrokcheck=false
    ngroklink=""
end

cflink=`grep -o 'https://[-0-9a-z]*\.trycloudflare.com' "$HOME/.cffolder/.log.txt"`.strip
if cflink.include?"cloudflare"
    cfcheck=true
else
    cfcheck=false
    cflink=""
end

loclxlink=`grep -o 'https://[-0-9a-z]*\.loclx.io' "$HOME/.loclxfolder/.log.txt"`.strip
if loclxlink.include?"loclx"
    loclxcheck=true
else
    loclxcheck=false
    loclxlink=""
end

while true
if cfcheck and ngrokcheck and loclxcheck
    puts "\n#{success}Cloudflared and Ngrok and Loclx started successfully!\n"
    puts "\n#{info}Cloudflare URL > #{yellow} #{cflink}"
    puts "\n#{info}Ngrok URL > #{yellow} #{ngroklink}"
    puts "\n#{info}Loclx URL > #{yellow} #{loclxlink}"
    break
end
if cfcheck and not ngrokcheck and not loclxcheck
    puts "\n#{success}Cloudflared started successfully!\n"
    puts "\n#{info}Cloudflare URL > #{yellow} #{cflink}"
    break
end
if not cfcheck and ngrokcheck and not loclxcheck
    puts "\n#{success}Ngrok started successfully!\n"
    puts "\n#{info}Ngrok URL > #{yellow} #{ngroklink}"
    break
end
if loclxcheck and not cfcheck and not ngrokcheck
    puts "\n#{success}Loclx started successfully!\n"
    puts "\n#{info}Loclx URL > #{yellow} #{loclxlink}"
    break
end
if loclxcheck and cfcheck and not ngrokcheck
    puts "\n#{success}Loclx and Cloudflared started successfully!\n"
    puts "\n#{info}Loclx URL > #{yellow} #{loclxlink}"
    puts "\n#{info}Cloudflare URL > #{yellow} #{cflink}"
    break
end
if not loclxcheck and cfcheck and ngrokcheck
    puts "\n#{success}Cloudflared and Ngrok started successfully!\n"
    puts "\n#{info}Cloudflared URL > #{yellow} #{cflink}"
    puts "\n#{info}Ngrok URL > #{yellow} #{ngroklink}"
    break
end
if loclxcheck and not cfcheck and ngrokcheck
    puts "\n#{success}Loclx and Ngrok started successfully!\n"
    puts "\n#{info}Loclx URL > #{yellow} #{loclxlink}"
    puts "\n#{info}Ngrok URL > #{yellow} #{ngroklink}"
    break
end
if not (cfcheck and ngrokcheck and loclxcheck)
    puts "\n#{error}Tunneling failed!\n"
    exit
end
end

# Automatically open Flask app in browser
puts "\n#{info}Opening Flask app in browser......."
app_url = nil
if cfcheck and cflink != ""
    app_url = cflink
elsif ngrokcheck and ngroklink != ""
    app_url = ngroklink
elsif loclxcheck and loclxlink != ""
    app_url = loclxlink
end

if app_url != nil and app_url != ""
    system("open '#{app_url}' 2>/dev/null")
    puts "#{success}Opened #{yellow}#{app_url}#{cyan} in browser!"
else
    puts "#{error}Could not determine tunnel URL to open Flask app"
end

puts "\n#{info}Press #{red}CTRL+C#{cyan} to exit!"
begin
    system("sleep 86400")
rescue SystemExit, Interrupt
    puts "\n#{success}Thanks for using!\n"
    exit
rescue Exception => e
    puts e
end

when "2"
system("clear")
puts logo
puts "\n\n#{red}[ToolName]  #{cyan}  :[Local2Internet - macOS]
#{red}[Version]    #{cyan} :[1.0]
#{red}[Description]#{cyan} :[LocalHost Exposing tool]
#{red}[Author]     #{cyan} :[Potato]
#{red}[Github]     #{cyan} :[https://github.com/xzPotato2z] 
#{red}[Messenger]  #{cyan} :[a]
#{red}[Email]      #{cyan} :[Negaous@gmail.com]"
print "\n#{ask}#{yellow}---> #{green}"
about=gets.chomp

when "0"
    exit
else
    puts "\n#{error}Wrong input. Please choose 1 or 2"
    system("sleep 2")
end
end