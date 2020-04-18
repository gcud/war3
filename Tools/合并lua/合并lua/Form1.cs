using System;
using System.IO;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Configuration;
namespace 合并lua
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            string PathListString = ReadConfig("PathList", "");
            if (PathListString != "")
            {
                PathComboBox.Items.AddRange(PathListString.Split(','));
            }
            PathComboBox.Text = ReadConfig("NowPath", "");
            SavePathMaxTextBox.Text = ReadConfig("SavePathMax", "10");
            LastMergeLabel.Text = ReadConfig("LastMerge","无");
        }
        private string ReadConfig(string Key, string Default)
        {
            if (ConfigurationManager.AppSettings[Key] == null)
            {
                return Default;
            }
            else
            {
                return ConfigurationManager.AppSettings[Key];
            }
        }

        private void button1_Click(object sender, EventArgs e)
        {
            AddUniqueConfig("PathList", PathComboBox.Text, Int32.Parse(SavePathMaxTextBox.Text));
            SaveConfig("SavePathMax", SavePathMaxTextBox.Text);
            SaveConfig("NowPath", PathComboBox.Text);
        }
        private void AddUniqueConfig(string Key, string Value, int Max = 0)
        {
            if (ConfigurationManager.AppSettings[Key] == null)
            {
                AddConfig(Key, Value, Max);
            }
            else
            {
                string[] Configs = ConfigurationManager.AppSettings[Key].Split(',');
                foreach (var item in Configs)
                {
                    if (item == Value)
                    {
                        return;
                    }
                }
                AddConfig(Key, Value, Max);
            }

        }
        private void AddConfig(string Key, string Value, int Max = 0)
        {
            Configuration config = ConfigurationManager.OpenExeConfiguration(ConfigurationUserLevel.None);
            config.AppSettings.Settings.Add(Key, Value);
            if (Max > 0)
            {
                List<string> Configs = config.AppSettings.Settings[Key].Value.Split(',').ToList();
                if (Configs.Count > Max)
                {
                    Configs.RemoveAt(0);
                }
                config.AppSettings.Settings[Key].Value = string.Join(",", Configs);
            }

            config.Save();
        }
        private void SaveConfig(string Key, string Value)
        {
            Configuration config = ConfigurationManager.OpenExeConfiguration(ConfigurationUserLevel.None);
            if (config.AppSettings.Settings[Key] == null)
            {
                config.AppSettings.Settings.Add(Key, Value);
            }
            else
            {
                config.AppSettings.Settings[Key].Value = Value;
            }
            config.Save();
        }

        private void button1_Click_1(object sender, EventArgs e)
        {
            string RootPath = PathComboBox.Text + Path.DirectorySeparatorChar;
            if (Directory.Exists(RootPath))
            {
                string[] Files = Directory.GetFiles(RootPath, "*.lua", SearchOption.AllDirectories);
                if (Files.Length > 0)
                {
                    StringBuilder sb = new StringBuilder();
                    foreach (var item in Files)
                    {
                        sb.Append(File.ReadAllText(item));
                        sb.Append(Environment.NewLine);
                    }
                    ContentTextBox.Text = sb.ToString();
                }
                else
                {
                    MessageBox.Show(PathComboBox.Text + " 没有lua文件");
                }
            }
            else
            {
                MessageBox.Show(PathComboBox.Text + " 不存在");
            }
            SaveConfig("LastMerge",DateTime.Now.ToString());
        }

        private void button2_Click(object sender, EventArgs e)
        {
            Clipboard.SetText(ContentTextBox.Text);
        }
    }
}
