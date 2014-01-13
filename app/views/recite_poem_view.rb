class RecitePoemView < UIView
  RP_VIEW_COLOR = UIColor.whiteColor

  PLAY_BUTTON_SIZE = 280
  PLAY_BUTTON_FONT_SIZE = PLAY_BUTTON_SIZE * 0.5
  PLAY_BUTTON_PAUSE_KEY = 'pause' # FontAwesomeのアイコン名から'fa-'を除いたもの
  PLAY_BUTTON_PLAY_KEY  = 'play'
  PLAY_BUTTON_CORNER_RADIUS = PLAY_BUTTON_SIZE / 2.0
  PLAY_MARK_INSET = PLAY_BUTTON_FONT_SIZE * 0.3
  PLAY_BUTTON_PLAYING_TITLE = FontAwesome.icon(PLAY_BUTTON_PLAY_KEY)
  PLAY_BUTTON_PAUSING_TITLE = FontAwesome.icon(PLAY_BUTTON_PAUSE_KEY)
  PLAY_BUTTON_PLAYING_COLOR = '#007bbb'.to_color # 紺碧
  PLAY_BUTTON_PAUSING_COLOR = '#e2041b'.to_color # 猩々緋

  TIME_SLIDER_HEIGHT = 50
  TIME_SLIDER_BOTTOM_MARGIN = 50
  TIME_SLIDER_INTERVAL = 0.5


  ACC_LABEL_PLAY_BUTTON = 'play_button'
  ACC_LABEL_TIME_SLICER = 'time_slider'

  attr_accessor :delegate, :dataSource
  attr_reader :play_button, :time_slider

  def initWithFrame(frame)
    super

    self.backgroundColor = RP_VIEW_COLOR
    set_play_button
    set_time_slider

    self
  end

  def start_reciting
    show_waiting_to_pause
    reset_time_slider
    @timer =
        NSTimer.scheduledTimerWithTimeInterval(TIME_SLIDER_INTERVAL,
                                               target: self,
                                               selector: :update_slider,
                                               userInfo: nil,
                                               repeats: true)
    true
  end

  def show_waiting_to_pause
    show_play_button_title(PLAY_BUTTON_PAUSING_TITLE,
                           left_inset: 0,
                           color: PLAY_BUTTON_PAUSING_COLOR)
  end

  def show_waiting_to_play
    show_play_button_title(PLAY_BUTTON_PLAYING_TITLE,
                           left_inset: PLAY_MARK_INSET,
                           color: PLAY_BUTTON_PLAYING_COLOR)
  end

  def play_finished_successfully
    @play_button.enabled = false
    @time_slider.enabled = false
    @timer.invalidate
  end

  def update_slider
    if dataSource && dataSource.respond_to?(:currentTime)
      @time_slider.value = self.dataSource.currentTime
    end
  end

  def slider_changed(sender)
    if dataSource && dataSource.respond_to?('current_time_changed_to:')
      self.dataSource.current_time_changed_to(@time_slider.value)
    end
    show_waiting_to_play
  end

  private

  def set_play_button
    @play_button = UIButton.buttonWithType(UIButtonTypeCustom)
    @play_button.tap do |b|
      b.frame = play_button_frame
      b.accessibilityLabel = ACC_LABEL_PLAY_BUTTON
      b.titleLabel.font = FontAwesome.fontWithSize(PLAY_BUTTON_FONT_SIZE)
      b.titleLabel.textAlignment = NSTextAlignmentCenter
      b.layer.tap do |l|
        l.cornerRadius = PLAY_BUTTON_CORNER_RADIUS
        l.masksToBounds = true
        l.borderWidth = 1.0
        l.borderColor = UIColor.darkGrayColor.CGColor
      end
      b.addTarget(self,
                  action: :play_button_pushed,
                  forControlEvents: UIControlEventTouchUpInside)

      self.addSubview(b)
    end
  end

  def play_button_frame
    [[(self.frame.size.width - PLAY_BUTTON_SIZE)/2, 150], [PLAY_BUTTON_SIZE, PLAY_BUTTON_SIZE]]
  end

  def set_time_slider
    @time_slider = UISlider.alloc.initWithFrame(time_slider_frame)
    @time_slider.addTarget(self,
                           action: 'slider_changed:',
                           forControlEvents: UIControlEventValueChanged)
    @time_slider.setThumbImage(UIImage.imageNamed('thumb01.png'),
                               forState: UIControlStateNormal)
    self.addSubview(@time_slider)
  end


  def time_slider_frame
    [[@play_button.frame.origin.x,
      self.frame.size.height - TIME_SLIDER_HEIGHT - TIME_SLIDER_BOTTOM_MARGIN],
     [@play_button.frame.size.width, TIME_SLIDER_HEIGHT]]
  end

  def reset_time_slider
    if dataSource and dataSource.respond_to?(:duration)
      @time_slider.maximumValue = dataSource.duration
      @time_slider.value = 0.0
    end
  end

  def play_button_pushed
    puts 'play_button pushed!'
    self.delegate.play_button_pushed(self)
  end

  def show_play_button_title(title, left_inset: l_inset, color: color)
    @play_button.tap do |b|
      UIEdgeInsets.new.tap do |insets|
        insets.left = l_inset
        b.contentEdgeInsets = insets
      end
      b.setTitle(title, forState: UIControlStateNormal)
      b.setTitleColor(color, forState: UIControlStateNormal)
      b.setTitleColor(color.colorWithAlphaComponent(0.25),
                      forState: UIControlStateHighlighted)
      b.setTitleColor(color.colorWithAlphaComponent(0.25),
                      forState: UIControlStateDisabled)
    end
  end





end