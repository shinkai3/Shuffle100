class GameEndView < UIView
  GAME_END_VIEW_TITLE =  '試合終了'
  BACK_TO_TOP_TITLE = 'トップに戻る'
  ACC_LABEL_BACK_TO_TOP_BUTTON = 'back_to_top'

  attr_accessor :delegate

  def initWithFrame(frame, header_height: height)
    self.initWithFrame(frame)
    self.backgroundColor= 'white'.to_color
    self.addSubview self.back_to_top_button
    self.addSubview self.header_view(height)

    self
  end


  def back_to_top_button
    @back_to_top_button ||=
        UIButton.buttonWithType(UIButtonTypeRoundedRect).tap do |b|
          b.frame = [[0, 0], [200, 80]]
          b.center = self.center
          b.setTitle(BACK_TO_TOP_TITLE, forState: UIControlStateNormal)
          b.addTarget(self,
                      action: :back_to_top_button_pushed,
                      forControlEvents: UIControlEventTouchUpInside)
          b.accessibilityLabel = ACC_LABEL_BACK_TO_TOP_BUTTON
        end
  end

  def back_to_top_button_pushed
    puts '[Back to Top] button pushed!' if BW::debug?

    self.delegate.back_to_top_screen
  end

  def header_view(height)
    @header_view ||=
        ReciteHeaderView.alloc.initWithFrame(header_view_frame(height)).tap do |view|
          view.title = GAME_END_VIEW_TITLE
        end
  end

  def header_view_frame(height)
    [[0, 0],
     [self.frame.size.width, height]]
  end
end