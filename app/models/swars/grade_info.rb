class Swars::GradeInfo
  include ApplicationMemoryRecord
  memory_record [
    {key: "九段", },
    {key: "八段", },
    {key: "七段", },
    {key: "六段", },
    {key: "五段", },
    {key: "四段", },
    {key: "三段", },
    {key: "二段", },
    {key: "初段", },
    {key:  "1級", },
    {key:  "2級", },
    {key:  "3級", },
    {key:  "4級", },
    {key:  "5級", },
    {key:  "6級", },
    {key:  "7級", },
    {key:  "8級", },
    {key:  "9級", },
    {key: "10級", },
    {key: "11級", },
    {key: "12級", },
    {key: "13級", },
    {key: "14級", },
    {key: "15級", },
    {key: "16級", },
    {key: "17級", },
    {key: "18級", },
    {key: "19級", },
    {key: "20級", },
    {key: "21級", },
    {key: "22級", },
    {key: "23級", },
    {key: "24級", },
    {key: "25級", },
    {key: "26級", },
    {key: "27級", },
    {key: "28級", },
    {key: "29級", },
    {key: "30級", },
  ]

  def priority
    code
  end
end
