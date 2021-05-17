using Core.Utilities;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(Animator))]
[RequireComponent(typeof(Poolable))]
public class PopUp : MonoBehaviour
{
	private Animator m_Animator;

	public void Show()
	{
		m_Animator.Play(0);
		Invoke(nameof(Hide), 0.5f);
	}

	public void Hide()
	{
		PoolManager.instance.ReturnPoolable(this.GetComponent<Poolable>());
	}

	private void Awake()
	{
		m_Animator = GetComponent<Animator>();
	}
}
