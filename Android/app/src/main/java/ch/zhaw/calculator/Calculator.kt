package ch.zhaw.calculator

import android.annotation.SuppressLint
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import ch.zhaw.calculator.databinding.FragmentCalculatorBinding

/**
 * A simple [Fragment] subclass as the default destination in the navigation.
 */
class Calculator : Fragment() {

  private var _binding: FragmentCalculatorBinding? = null
  private var firstNumber: Int? = null
  private var fillingNumber: Int? = null
  private var operator: Char? = null

  // This property is only valid between onCreateView and
  // onDestroyView.
  private val binding get() = _binding!!

  override fun onCreateView(
    inflater: LayoutInflater, container: ViewGroup?,
    savedInstanceState: Bundle?
  ): View? {

    _binding = FragmentCalculatorBinding.inflate(inflater, container, false)
    return binding.root

  }

  @SuppressLint("SetTextI18n")
  override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
    super.onViewCreated(view, savedInstanceState)

    binding.number0.setOnClickListener { clickedNumber(0) }

    binding.number01.setOnClickListener { clickedNumber(1) }

    binding.number02.setOnClickListener { clickedNumber(2) }

    binding.number03.setOnClickListener { clickedNumber(3) }

    binding.number04.setOnClickListener { clickedNumber(4) }

    binding.number05.setOnClickListener { clickedNumber(5) }

    binding.number06.setOnClickListener { clickedNumber(6) }

    binding.number07.setOnClickListener { clickedNumber(7) }

    binding.number08.setOnClickListener { clickedNumber(8) }

    binding.number09.setOnClickListener { clickedNumber(9) }

    binding.clear.setOnClickListener {
      binding.result.text = ""
      firstNumber = null
      fillingNumber = null
      operator = null
    }

    binding.plus.setOnClickListener { clickedOperator('+') }

    binding.minus.setOnClickListener { clickedOperator('-') }

    binding.multiply.setOnClickListener { clickedOperator('*') }

    binding.divide.setOnClickListener { clickedOperator('/') }

    binding.equals.setOnClickListener {
      calculate()
    }

  }

  @SuppressLint("SetTextI18n")
  private fun clickedNumber(i: Int) {
    fillingNumber = fillingNumber?.times(10)?.plus(i) ?: i
    binding.result.text = fillingNumber.toString()
  }

  private fun clickedOperator(c: Char) {
    calculate()
    operator = c
    if (fillingNumber != null) {
      firstNumber = fillingNumber
    }
    fillingNumber = null
  }

  @SuppressLint("SetTextI18n")
  private fun calculate() {
    if (firstNumber != null && operator != null && fillingNumber != null) {
      var result = 0
      when (operator) {
        '+' -> result = firstNumber!! + fillingNumber!!
        '-' -> result = firstNumber!! - fillingNumber!!
        '*' -> result = firstNumber!! * fillingNumber!!
        '/' -> {
          if (fillingNumber == 0) {
            binding.result.text = "Error"
            return
          }
          else{
            result = firstNumber!! / fillingNumber!!
          }
        }
      }
      firstNumber = result
      binding.result.text = firstNumber.toString()
      fillingNumber = null
    }
  }

  override fun onDestroyView() {
    super.onDestroyView()
    _binding = null
  }
}
