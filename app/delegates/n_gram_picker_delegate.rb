module NGramPickerDelegate
  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
#    puts "- 選ばれた1文字目は[#{id_of(indexPath)}]です。"
    case selected_status_of_char(id_of(indexPath))
      when :full ; release_poems_of_char(id_of(indexPath))
      else       ; select_all_poems_of_char(id_of(indexPath))
    end
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    @table_view.reloadData
  end

  def tableView(tableView, willDisplayCell: cell, forRowAtIndexPath: indexPath)
    self.navigationItem.prompt = '選択中: %d首' % @status100.selected_num
  end


  def select_all_poems_of_char(char_sym)
    @status100.select_in_numbers(NGramNumbers.of(char_sym))
    save_selected_status(@status100)
  end

  def release_poems_of_char(char_sym)
    @status100.cancel_in_numbers(NGramNumbers.of(char_sym))
    save_selected_status(@status100)
  end


  def selected_status_of_char(sym)
    raise "Invalid argument type #{sym}" unless sym.is_a?(Symbol)
    numbers = NGramNumbers.of(sym)
    raise "Couldn't get NgramNumbers for #{sym}" unless numbers
    if numbers.inject(true){|result, num| result &&= @status100.of_number(num)}
      :full # 該当する歌が全て選択されているとき
    elsif !numbers.inject(false) { |result, num| result ||= @status100.of_number(num) }
      :none # 該当する歌が一つも選択されてないとき
    else
      :partial # 中途半端に選択されているとき
    end
  end

end