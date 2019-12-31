Pod::Spec.new do |s|
    s.name             = 'MaterialForm'
    s.version          = '0.0.2'
    s.summary          = 'Material UI Text Field for both UIKit (iOS 10+) and SwiftUI (iOS 13+).'
    s.description      = <<-DESC
    Defines reusable and observable Material text field component, that works both with UIKit (iOS 10+) and SwiftUI (iOS 13+).
                        DESC

    s.homepage         = 'https://github.com/GirAppe/MaterialForm.git'
    s.screenshots      = 'https://raw.githubusercontent.com/GirAppe/MaterialForm/0.0.1/material-form-light.gif', 'https://raw.githubusercontent.com/GirAppe/MaterialForm/0.0.1/material-form-dark.gif'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'Andrzej Michnia' => 'amichnia@gmail.com' }
    s.source           = { :git => 'https://github.com/GirAppe/MaterialForm.git', :tag => s.version.to_s }

    s.ios.deployment_target = '10.0'
    s.tvos.deployment_target = '10.0'
    s.preserve_paths = '*'
    s.swift_versions = ['5.0', '5.1.2']
    s.source_files = 'Sources/MaterialForm/**/*'
    s.frameworks = 'UIKit'
end
