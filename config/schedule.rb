user = `whoami`.chomp

every 2.minutes do
  command "echo 'beginning check' >> /Users/robertgrayson/spectrum.log && ruby /Users/robertgrayson/spectrum_snitch/main.rb && echo 'finished check' >> /Users/robertgrayson/spectrum.log"
end

