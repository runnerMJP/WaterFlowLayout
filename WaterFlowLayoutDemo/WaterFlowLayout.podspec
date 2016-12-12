Pod::Spec.new do |s|
s.name = 'WaterflowLayout'
s.version = '1.0.0'
s.license = 'MIT'
s.summary = 'A Waterfall flow layout on iOS.'
s.homepage = 'https://github.com/runnerMJP/WaterFlowLayout'
s.authors = { 'runner' => 'mjping1992@163.com }
s.source = { :git => 'https://github.com/runnerMJP/WaterFlowLayout.git', :tag => '0.0.1' }
s.requires_arc = true
s.ios.deployment_target = '8.0'
s.source_files = 'WaterFlowLayoutDemo/WaterflowLayout.h'
s.resources = 'WaterFlowLayoutDemo/WaterflowLayout.h'
end
