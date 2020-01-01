## [ Xcode ] ###################################################################

desc "Open the project in Xcode"
task :xcode do
    ARGV.each { |a| task a.to_sym do ; end }
    app = ARGV[1].to_s
    project = "./MaterialForm.xcodeproj"
    sh "open #{project}"
end

## [ Deploy ] ##################################################################

desc "Deploys new version of a binary, by pushing passed tag"
task :deploy do
    ARGV.each { |a| task a.to_sym do ; end }
    version = ARGV[1].to_s
    if version
        sh("git tag #{version} && git push --tags")
        sh("pod trunk push")
    end
end

## [ Helpers ] #################################################################

desc "Purge Derived data"
task :purge do
    sh("rm -rf ~/Library/Developer/Xcode/DerivedData/*")
end

def print_info(str)
    (red,clr) = (`tput colors`.chomp.to_i >= 8) ? %W(\e[33m \e[m) : ["", ""]
    puts red, "== #{str.chomp} ==", clr
end
