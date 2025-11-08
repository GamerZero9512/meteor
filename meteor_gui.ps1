param(
    [string]$StartIn = (Get-Location)
)

Write-Host "meteorRename`r`n"
Write-Host "This is the console window. Ignore it.`r`nClose either window to exit meteorRename.`r`n"

Set-Location "$StartIn"
Add-Type -AssemblyName PresentationFramework
. "$PSScriptRoot\meteor_actions.ps1"   # Import functions from actions file

# Define XAML UI
$xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="meteorRename: $StartIn"
        Height="660" Width="350"
        WindowStartupLocation="CenterScreen"
        Background="#2C2C2C"
	ResizeMode="CanResize"
        FontFamily="Segoe UI">
  <ScrollViewer VerticalScrollBarVisibility="Auto">
  <StackPanel Margin="15" VerticalAlignment="Top">

    <!-- Search / Replace -->
    <TextBlock Text="Search:" Foreground="White" Margin="0,0,0,3"/>
    <TextBox x:Name="SearchBox" Height="30" Background="#3A3A3A" Foreground="White" BorderThickness="0" Padding="8" Margin="0,0,0,10" />

    <TextBlock Text="Replace:" Foreground="White" Margin="0,0,0,3"/>
    <TextBox x:Name="ReplaceBox" Height="30" Background="#3A3A3A" Foreground="White" BorderThickness="0" Padding="8" Margin="0,0,0,10" />

    <Button x:Name="BtnSearchReplace" Content="Search and Replace" Height="35" Margin="0,0,0,15"
            Background="#4A90E2" Foreground="White" BorderThickness="0" FontWeight="SemiBold" Cursor="Hand">
      <Button.Resources>
        <Style TargetType="Button">
          <Setter Property="Template">
            <Setter.Value>
              <ControlTemplate TargetType="Button">
                <Border Background="{TemplateBinding Background}" CornerRadius="6">
                  <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
                </Border>
              </ControlTemplate>
            </Setter.Value>
          </Setter>
        </Style>
      </Button.Resources>
    </Button>

    <!-- Prefix -->
    <TextBlock Text="Prefix:" Foreground="White" Margin="0,0,0,3"/>
    <TextBox x:Name="PrefixBox" Height="30" Background="#3A3A3A" Foreground="White" BorderThickness="0" Padding="8" Margin="0,0,0,10" />
    <Button x:Name="BtnPrefix" Content="Add Prefix" Height="35" Margin="0,0,0,15"
            Background="#4CAF50" Foreground="White" BorderThickness="0" FontWeight="SemiBold" Cursor="Hand">
      <Button.Resources>
        <Style TargetType="Button">
          <Setter Property="Template">
            <Setter.Value>
              <ControlTemplate TargetType="Button">
                <Border Background="{TemplateBinding Background}" CornerRadius="6">
                  <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
                </Border>
              </ControlTemplate>
            </Setter.Value>
          </Setter>
        </Style>
      </Button.Resources>
    </Button>

    <!-- Suffix -->
    <TextBlock Text="Suffix:" Foreground="White" Margin="0,0,0,3"/>
    <TextBox x:Name="SuffixBox" Height="30" Background="#3A3A3A" Foreground="White" BorderThickness="0" Padding="8" Margin="0,0,0,10" />
    <Button x:Name="BtnSuffix" Content="Add Suffix" Height="35" Margin="0,0,0,15"
            Background="#FF9800" Foreground="White" BorderThickness="0" FontWeight="SemiBold" Cursor="Hand">
      <Button.Resources>
        <Style TargetType="Button">
          <Setter Property="Template">
            <Setter.Value>
              <ControlTemplate TargetType="Button">
                <Border Background="{TemplateBinding Background}" CornerRadius="6">
                  <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
                </Border>
              </ControlTemplate>
            </Setter.Value>
          </Setter>
        </Style>
      </Button.Resources>
    </Button>

    <!-- Rename and Number -->
    <TextBlock Text="Rename:" Foreground="White" Margin="0,0,0,3"/>
    <TextBox x:Name="RenameBox" Height="30" Background="#3A3A3A" Foreground="White" BorderThickness="0" Padding="8" Margin="0,0,0,10" />

    <StackPanel Orientation="Horizontal" Margin="0,0,0,10">
      <StackPanel Width="150">
        <TextBlock Text="Start #:" Foreground="White" Margin="0,0,0,3"/>
        <TextBox x:Name="StartNum" Height="30" Width="130" Background="#3A3A3A" Foreground="White" BorderThickness="0" Padding="8"/>
      </StackPanel>
      <StackPanel Width="150" Margin="20,0,0,0">
        <TextBlock Text="Padding:" Foreground="White" Margin="0,0,0,3"/>
        <TextBox x:Name="PaddingBox" Height="30" Width="130" Background="#3A3A3A" Foreground="White" BorderThickness="0" Padding="8"/>
      </StackPanel>
    </StackPanel>

    <Button x:Name="BtnRenameNum" Content="Rename and Number" Height="35" Margin="0,0,0,15"
            Background="#9C27B0" Foreground="White" BorderThickness="0" FontWeight="SemiBold" Cursor="Hand">
      <Button.Resources>
        <Style TargetType="Button">
          <Setter Property="Template">
            <Setter.Value>
              <ControlTemplate TargetType="Button">
                <Border Background="{TemplateBinding Background}" CornerRadius="6">
                  <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
                </Border>
              </ControlTemplate>
            </Setter.Value>
          </Setter>
        </Style>
      </Button.Resources>
    </Button>

    <!-- Lowercase -->
    <Button x:Name="BtnLowercase" Content="Change to Lowercase" Height="35"
            Background="#616161" Foreground="White" BorderThickness="0" FontWeight="SemiBold" Cursor="Hand">
      <Button.Resources>
        <Style TargetType="Button">
          <Setter Property="Template">
            <Setter.Value>
              <ControlTemplate TargetType="Button">
                <Border Background="{TemplateBinding Background}" CornerRadius="6">
                  <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
                </Border>
              </ControlTemplate>
            </Setter.Value>
          </Setter>
        </Style>
      </Button.Resources>
    </Button>

  </StackPanel>
  </ScrollViewer>
</Window>
"@

# Load the XAML
$reader = [System.IO.StringReader]::new($xaml)
$xmlReader = [System.Xml.XmlReader]::Create($reader)
$window = [Windows.Markup.XamlReader]::Load($xmlReader)

# Bind controls
$BtnSearchReplace = $window.FindName("BtnSearchReplace")
$BtnPrefix = $window.FindName("BtnPrefix")
$BtnSuffix = $window.FindName("BtnSuffix")
$BtnRenameNum = $window.FindName("BtnRenameNum")
$BtnLowercase = $window.FindName("BtnLowercase")

$SearchBox = $window.FindName("SearchBox")
$ReplaceBox = $window.FindName("ReplaceBox")
$PrefixBox = $window.FindName("PrefixBox")
$SuffixBox = $window.FindName("SuffixBox")
$RenameBox = $window.FindName("RenameBox")
$StartNum = $window.FindName("StartNum")
$PaddingBox = $window.FindName("PaddingBox")

# Wire up events
$BtnSearchReplace.Add_Click({ SearchAndReplace $SearchBox.Text $ReplaceBox.Text })
$BtnPrefix.Add_Click({ AddPrefix $PrefixBox.Text })
$BtnSuffix.Add_Click({ AddSuffix $SuffixBox.Text })
$BtnRenameNum.Add_Click({ RenameAndNumber $RenameBox.Text $StartNum.Text $PaddingBox.Text })
$BtnLowercase.Add_Click({ LowercaseAll })

# Run the GUI
$window.ShowDialog() | Out-Null
