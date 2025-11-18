#!/usr/bin/env ruby
# Tunnel script for Flask app on port 5000

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

success = green + '[' + white + '√' + green + '] '
error = red + '[' + white + '!' + red + '] '
info= yellow + '[' + white + '+' + yellow + '] '+ cyan
pw= yellow + '[' + white + '+' +yellow + ']'+' Please Wait!'

puts pw
root=`echo $HOME`.strip

# Function to find an available port
def find_available_port(start_port = 5000, max_attempts = 10)
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

# Check if Flask is running on any common port
flask_found = false
[5000, 5001, 5002, 5003, 5004, 8080, 8088].each do |p|
    check_flask = `curl -s --head -w %{http_code} 127.0.0.1:#{p} -o /dev/null 2>/dev/null`.strip
    if check_flask != "" and not check_flask.include?"000"
        port = p
        flask_found = true
        puts "\n#{info}Found Flask server running on port #{port}!"
        break
    end
end

if not flask_found
    puts "\n#{info}No Flask server detected. Will start on port #{port}..."
    puts "#{info}Starting Flask server on port #{port}..."
    path = "/Users/potato/Desktop/school type"
    if File.file?("#{path}/app.py")
        system("cd #{path} && FLASK_PORT=#{port} python3 app.py #{port} > /dev/null 2>&1 &")
        system("sleep 3")
        check_flask = `curl -s --head -w %{http_code} 127.0.0.1:#{port} -o /dev/null 2>/dev/null`.strip
        if check_flask.include?"000" or check_flask == ""
            puts "\n#{error}Flask server failed to start on port #{port}!"
            exit
        end
        puts "#{success}Flask server started on port #{port}!"
    else
        puts "\n#{error}app.py not found in #{path}!"
        exit
    end
end

# Kill existing tunnel processes
checkngrok=`pgrep ngrok`
checkcf=`pgrep cloudflared`
checkloclx=`pgrep loclx`

if checkngrok!=""
    system("killall ngrok 2>/dev/null")
end
if checkcf!=""
    system("killall cloudflared 2>/dev/null")
end
if checkloclx!=""
    system("killall loclx 2>/dev/null")
end

# Check if Homebrew is installed
homebrew=`which brew 2>/dev/null`.strip
if homebrew==""
    puts "\n#{error}Homebrew is not installed!"
    puts "#{info}Please install Homebrew from https://brew.sh"
    exit
end

arc=`uname -m`.strip
system("stty -echoctl")

# Download ngrok if not exists
if not File.file?(root+"/.ngrokfolder/ngrok")
    system("rm -rf ngrok.zip ngrok")
    puts "\n#{info}Downloading Ngrok......."
    if arc.include?"arm64"
        system("wget -q --show-progress https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-darwin-arm64.zip -O ngrok.zip 2>/dev/null")
    else
        system("wget -q --show-progress https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-darwin-amd64.zip -O ngrok.zip 2>/dev/null")
    end
    system("unzip -q ngrok.zip && rm -rf ngrok.zip 2>/dev/null")
    system("mkdir -p $HOME/.ngrokfolder && mv -f ngrok $HOME/.ngrokfolder 2>/dev/null && chmod +x $HOME/.ngrokfolder/ngrok 2>/dev/null")
end

# Download cloudflared if not exists
if not File.file?(root+"/.cffolder/cloudflared")
    system("rm -rf cloudflared cloudflared.tgz")
    puts "\n#{info}Downloading Cloudflared......."
    if arc.include?"arm64"
        system("wget -q --show-progress https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-darwin-arm64.tgz -O cloudflared.tgz 2>/dev/null")
        system("tar -xzf cloudflared.tgz && rm -rf cloudflared.tgz 2>/dev/null")
    else
        system("wget -q --show-progress https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-darwin-amd64.tgz -O cloudflared.tgz 2>/dev/null")
        system("tar -xzf cloudflared.tgz && rm -rf cloudflared.tgz 2>/dev/null")
    end
    system("mkdir -p $HOME/.cffolder && mv -f cloudflared $HOME/.cffolder 2>/dev/null && chmod +x $HOME/.cffolder/cloudflared 2>/dev/null")
end

# Download loclx if not exists
if not File.file?(root+"/.loclxfolder/loclx")
    system("rm -rf loclx.zip loclx")
    puts "\n#{info}Downloading Loclx......."
    if arc.include?"arm64"
        system("wget -q --show-progress https://lxpdownloads.sgp1.digitaloceanspaces.com/cli/loclx-darwin-arm64.zip -O loclx.zip 2>/dev/null")
    else
        system("wget -q --show-progress https://lxpdownloads.sgp1.digitaloceanspaces.com/cli/loclx-darwin-amd64.zip -O loclx.zip 2>/dev/null")
    end
    system("unzip -q loclx.zip && rm -rf loclx.zip 2>/dev/null")
    system("mkdir -p $HOME/.loclxfolder && mv -f loclx $HOME/.loclxfolder 2>/dev/null && chmod +x $HOME/.loclxfolder/loclx 2>/dev/null")
end

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

puts "#{info}Flask Server: #{green}Running on port #{port}#{cyan}"
puts "#{info}Directory: #{green}/Users/potato/Desktop/school type#{cyan}"
puts "\n#{info}Starting tunnelers.......\n"

system("rm -rf $HOME/.cffolder/.log.txt 2>/dev/null")
system("rm -rf $HOME/.loclxfolder/.log.txt 2>/dev/null")

# Start tunnelers
system("cd $HOME/.ngrokfolder && ./ngrok http #{port} > /dev/null 2>&1 &")
system("cd $HOME/.cffolder && ./cloudflared tunnel -url 127.0.0.1:#{port} --logfile .log.txt > /dev/null 2>&1 &")
system("cd $HOME/.loclxfolder && ./loclx tunnel http --to :#{port} > .log.txt 2> /dev/null &")

system("sleep 8")

# Get tunnel URLs
ngroklink=`curl -s -N http://127.0.0.1:4040/api/tunnels 2>/dev/null | grep -oE "https://[a-z0-9-]+\.ngrok(-free)?\.(io|dev)" | head -1`.strip
if ngroklink.include?"ngrok"
    ngrokcheck=true
else
    ngrokcheck=false
    ngroklink=""
end

cflink=`grep -o 'https://[-0-9a-z]*\.trycloudflare.com' "$HOME/.cffolder/.log.txt" 2>/dev/null`.strip
if cflink.include?"cloudflare"
    cfcheck=true
else
    cfcheck=false
    cflink=""
end

loclxlink=`grep -o 'https://[-0-9a-z]*\.loclx.io' "$HOME/.loclxfolder/.log.txt" 2>/dev/null`.strip
if loclxlink.include?"loclx"
    loclxcheck=true
else
    loclxcheck=false
    loclxlink=""
end

# Display results
puts "\n"
if cfcheck
    puts "#{success}Cloudflare URL > #{yellow}#{cflink}#{cyan}"
end
if ngrokcheck
    puts "#{success}Ngrok URL > #{yellow}#{ngroklink}#{cyan}"
end
if loclxcheck
    puts "#{success}Loclx URL > #{yellow}#{loclxlink}#{cyan}"
end

if not (cfcheck or ngrokcheck or loclxcheck)
    puts "\n#{error}Tunneling failed! Please check your internet connection."
    exit
end

puts "\n#{info}Press #{red}CTRL+C#{cyan} to exit!"
begin
    system("sleep 86400")
rescue SystemExit, Interrupt
    puts "\n#{success}Thanks for using!\n"
    system("killall ngrok cloudflared loclx 2>/dev/null")
    exit
rescue Exception => e
    puts e
end

