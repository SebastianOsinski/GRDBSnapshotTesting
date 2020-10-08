#
# Be sure to run `pod lib lint GRDBSnapshotTesting.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'GRDBSnapshotTesting'
  s.version          = '0.3.0'
  s.summary          = 'Snapshot tests for GRDB database migrations'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  SnapshotTesting plug-in for testing GRDB database migrations.
                       DESC

  s.homepage         = 'https://github.com/SebastianOsinski/GRDBSnapshotTesting'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'SebastianOsinski' => 'seb.osinski@gmail.com' }
  s.source           = { :git => 'https://github.com/SebastianOsinski/GRDBSnapshotTesting.git', :tag => s.version.to_s }

  s.swift_version = "5.0"

  s.ios.deployment_target = '11.0'

  s.source_files = 'GRDBSnapshotTesting/Sources/**/*.swift'
  
  s.dependency 'GRDB.swift', '~> 5'
  s.dependency 'SnapshotTesting', '~> 1.8'

  s.frameworks = "XCTest"
  s.pod_target_xcconfig = { 'ENABLE_BITCODE' => 'NO' }
end
