using Core.UI;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class OptionsMenu : SimpleMainMenuPage
{
	public Slider masterSlider;

	public Slider sfxSlider;

	public Slider musicSlider;

	public Slider scrollSpeedSlider;
	public Text scrollSpeedText;

	public void UpdateScrollSpeed()
	{
		var scrollSpeed = scrollSpeedSlider.value;
		scrollSpeedText.text = scrollSpeed.ToString();
	}

	/// <summary>
	/// Event fired when sliders change
	/// </summary>
	public void UpdateVolumes()
	{
		float masterVolume, sfxVolume, musicVolume;
		GetSliderVolumes(out masterVolume, out sfxVolume, out musicVolume);

		if (GameManager.instanceExists)
		{
			GameManager.instance.SetVolumes(masterVolume, sfxVolume, musicVolume, false);
		}
	}

	/// <summary>
	/// Set initial slider values
	/// </summary>
	public override void Show()
	{
		if (GameManager.instanceExists)
		{
			float master, sfx, music;
			GameManager.instance.GetVolumes(out master, out sfx, out music);

			if (masterSlider != null)
			{
				masterSlider.value = master;
			}
			if (sfxSlider != null)
			{
				sfxSlider.value = sfx;
			}
			if (musicSlider != null)
			{
				musicSlider.value = music;
			}

			scrollSpeedSlider.value = GameManager.instance.ScrollSpeed;
			scrollSpeedText.text = GameManager.instance.ScrollSpeed.ToString();
		}

		base.Show();
	}

	/// <summary>
	/// Persist volumes to data store
	/// </summary>
	public override void Hide()
	{
		float masterVolume, sfxVolume, musicVolume;
		GetSliderVolumes(out masterVolume, out sfxVolume, out musicVolume);

		if (GameManager.instanceExists)
		{
			GameManager.instance.SetVolumes(masterVolume, sfxVolume, musicVolume, true);
			GameManager.instance.ScrollSpeed = scrollSpeedSlider.value;
		}

		base.Hide();
	}

	/// <summary>
	/// Retrieve values from sliders
	/// </summary>
	void GetSliderVolumes(out float masterVolume, out float sfxVolume, out float musicVolume)
	{
		masterVolume = masterSlider != null ? masterSlider.value : 1;
		sfxVolume = sfxSlider != null ? sfxSlider.value : 1;
		musicVolume = musicSlider != null ? musicSlider.value : 1;
	}
}
